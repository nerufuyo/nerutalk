import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/services/profile_service.dart';
import '../../domain/models/profile_models.dart';

/// Profile controller for managing profile UI state and interactions
class ProfileController extends GetxController {
  final ProfileService _profileService = Get.find<ProfileService>();

  // Form controllers
  final displayNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final websiteController = TextEditingController();
  final statusMessageController = TextEditingController();

  // Observable properties
  final RxBool _isEditing = false.obs;
  final Rx<String> _selectedStatus = 'online'.obs;
  final Rx<DateTime?> _selectedDateOfBirth = Rx<DateTime?>(null);
  final RxBool _showPrivacySettings = false.obs;

  // Getters from service
  UserProfile? get currentProfile => _profileService.currentProfile;
  List<ProfileActivity> get activities => _profileService.activities;
  AvatarUpload? get currentAvatarUpload => _profileService.currentAvatarUpload;
  bool get isLoading => _profileService.isLoading;
  bool get isUpdatingProfile => _profileService.isUpdatingProfile;
  bool get isUploadingAvatar => _profileService.isUploadingAvatar;

  // Local getters
  bool get isEditing => _isEditing.value;
  String get selectedStatus => _selectedStatus.value;
  DateTime? get selectedDateOfBirth => _selectedDateOfBirth.value;
  bool get showPrivacySettings => _showPrivacySettings.value;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadProfileData();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  /// Initialize form controllers with current profile data
  void _initializeControllers() {
    final profile = currentProfile;
    if (profile != null) {
      displayNameController.text = profile.displayName ?? '';
      firstNameController.text = profile.firstName ?? '';
      lastNameController.text = profile.lastName ?? '';
      bioController.text = profile.bio ?? '';
      phoneController.text = profile.phoneNumber ?? '';
      locationController.text = profile.location ?? '';
      websiteController.text = profile.website ?? '';
      statusMessageController.text = profile.statusMessage ?? '';
      _selectedStatus.value = profile.status ?? 'online';
      _selectedDateOfBirth.value = profile.dateOfBirth;
    }
  }

  /// Dispose form controllers
  void _disposeControllers() {
    displayNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    locationController.dispose();
    websiteController.dispose();
    statusMessageController.dispose();
  }

  /// Load profile data
  Future<void> _loadProfileData() async {
    await _profileService.loadCurrentProfile();
    await _profileService.loadProfileActivities();
    _initializeControllers();
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await _loadProfileData();
  }

  /// Toggle edit mode
  void toggleEditMode() {
    _isEditing.value = !_isEditing.value;
    if (!_isEditing.value) {
      // Reset controllers if cancelled
      _initializeControllers();
    }
  }

  /// Save profile changes
  Future<void> saveProfile() async {
    final updates = <String, dynamic>{};

    // Collect changes
    if (displayNameController.text != (currentProfile?.displayName ?? '')) {
      updates['display_name'] = displayNameController.text.trim();
    }
    if (firstNameController.text != (currentProfile?.firstName ?? '')) {
      updates['first_name'] = firstNameController.text.trim();
    }
    if (lastNameController.text != (currentProfile?.lastName ?? '')) {
      updates['last_name'] = lastNameController.text.trim();
    }
    if (bioController.text != (currentProfile?.bio ?? '')) {
      updates['bio'] = bioController.text.trim();
    }
    if (phoneController.text != (currentProfile?.phoneNumber ?? '')) {
      updates['phone_number'] = phoneController.text.trim();
    }
    if (locationController.text != (currentProfile?.location ?? '')) {
      updates['location'] = locationController.text.trim();
    }
    if (websiteController.text != (currentProfile?.website ?? '')) {
      updates['website'] = websiteController.text.trim();
    }
    if (_selectedDateOfBirth.value != currentProfile?.dateOfBirth) {
      updates['date_of_birth'] = _selectedDateOfBirth.value?.toIso8601String();
    }

    if (updates.isNotEmpty) {
      final success = await _profileService.updateProfile(updates);
      if (success) {
        _isEditing.value = false;
      }
    } else {
      _isEditing.value = false;
    }
  }

  /// Update status
  Future<void> updateStatus(String status, {String? statusMessage}) async {
    _selectedStatus.value = status;
    await _profileService.updateStatus(status, statusMessage: statusMessage);
  }

  /// Update status message
  Future<void> updateStatusMessage() async {
    await _profileService.updateStatus(
      _selectedStatus.value,
      statusMessage: statusMessageController.text.trim(),
    );
  }

  /// Select date of birth
  Future<void> selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate:
          _selectedDateOfBirth.value ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(
        const Duration(days: 365 * 13),
      ), // 13+ years old
    );

    if (picked != null) {
      _selectedDateOfBirth.value = picked;
    }
  }

  /// Show avatar options
  void showAvatarOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Profile Photo', style: Get.textTheme.headlineSmall),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                _profileService.pickAndUploadAvatar(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                _profileService.pickAndUploadAvatar(
                  source: ImageSource.gallery,
                );
              },
            ),
            if (currentProfile?.avatarUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo'),
                textColor: Colors.red,
                onTap: () {
                  Get.back();
                  _showRemoveAvatarConfirmation();
                },
              ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
      backgroundColor: Get.theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  /// Show remove avatar confirmation
  void _showRemoveAvatarConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Profile Photo'),
        content: const Text(
          'Are you sure you want to remove your profile photo?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _profileService.removeAvatar();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  /// Toggle privacy settings visibility
  void togglePrivacySettings() {
    _showPrivacySettings.value = !_showPrivacySettings.value;
  }

  /// Update privacy setting
  Future<void> updatePrivacySetting(String setting, bool value) async {
    final currentSettings =
        currentProfile?.privacySettings ??
        ProfilePrivacySettings(userId: currentProfile?.id ?? '');

    ProfilePrivacySettings updatedSettings;

    switch (setting) {
      case 'show_email':
        updatedSettings = currentSettings.copyWith(showEmail: value);
        break;
      case 'show_phone_number':
        updatedSettings = currentSettings.copyWith(showPhoneNumber: value);
        break;
      case 'show_last_seen':
        updatedSettings = currentSettings.copyWith(showLastSeen: value);
        break;
      case 'show_online_status':
        updatedSettings = currentSettings.copyWith(showOnlineStatus: value);
        break;
      case 'allow_search_by_email':
        updatedSettings = currentSettings.copyWith(allowSearchByEmail: value);
        break;
      case 'allow_search_by_phone':
        updatedSettings = currentSettings.copyWith(allowSearchByPhone: value);
        break;
      case 'show_location':
        updatedSettings = currentSettings.copyWith(showLocation: value);
        break;
      case 'allow_location_sharing':
        updatedSettings = currentSettings.copyWith(allowLocationSharing: value);
        break;
      case 'allow_friend_requests':
        updatedSettings = currentSettings.copyWith(allowFriendRequests: value);
        break;
      case 'allow_group_invites':
        updatedSettings = currentSettings.copyWith(allowGroupInvites: value);
        break;
      case 'allow_calls_from_contacts':
        updatedSettings = currentSettings.copyWith(
          allowCallsFromContacts: value,
        );
        break;
      case 'allow_calls_from_anyone':
        updatedSettings = currentSettings.copyWith(allowCallsFromAnyone: value);
        break;
      default:
        return;
    }

    await _profileService.updatePrivacySettings(updatedSettings);
  }

  /// Update profile visibility
  Future<void> updateProfileVisibility(String visibility) async {
    final currentSettings =
        currentProfile?.privacySettings ??
        ProfilePrivacySettings(userId: currentProfile?.id ?? '');

    final updatedSettings = currentSettings.copyWith(
      profileVisibility: visibility,
    );
    await _profileService.updatePrivacySettings(updatedSettings);
  }

  /// Show deactivate account confirmation
  void showDeactivateAccountConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Deactivate Account'),
        content: const Text(
          'Are you sure you want to deactivate your account? You can reactivate it by logging in again.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _profileService.deactivateAccount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  /// Show delete account confirmation
  void showDeleteAccountConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showFinalDeleteConfirmation();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Show final delete confirmation
  void _showFinalDeleteConfirmation() {
    final confirmationController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Type "DELETE" to confirm account deletion:'),
            const SizedBox(height: 10),
            TextField(
              controller: confirmationController,
              decoration: const InputDecoration(
                hintText: 'Type DELETE',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          Obx(
            () => ElevatedButton(
              onPressed: confirmationController.text == 'DELETE'
                  ? () {
                      Get.back();
                      _profileService.deleteAccount();
                    }
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Account'),
            ),
          ),
        ],
      ),
    );
  }

  /// Export user data
  Future<void> exportUserData() async {
    await _profileService.exportUserData();
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    await _profileService.sendEmailVerification();
  }

  /// Get profile completion percentage
  int get profileCompletionPercentage =>
      currentProfile?.profileCompletionPercentage ?? 0;

  /// Get status color
  Color getStatusColor(String? status) {
    final colorHex = _profileService.getStatusColor(status);
    return Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
  }

  /// Get status display name
  String getStatusDisplayName(String? status) {
    return _profileService.getStatusDisplayName(status);
  }

  /// Format file size
  String formatFileSize(int bytes) {
    return _profileService.formatFileSize(bytes);
  }

  /// Get time ago string
  String getTimeAgo(DateTime dateTime) {
    return _profileService.getTimeAgo(dateTime);
  }
}
