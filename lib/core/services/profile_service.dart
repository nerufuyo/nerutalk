import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../config/app_config.dart';
import '../constants/app_strings.dart';
import '../../domain/models/profile_models.dart';
import '../../domain/models/user_models.dart';
import 'network_service.dart';
import 'auth_service.dart';

/// Profile management service
/// Handles user profile operations, avatar uploads, and privacy settings
class ProfileService extends GetxService {
  static ProfileService get to => Get.find();

  final NetworkService _networkService = Get.find<NetworkService>();
  final AuthService _authService = Get.find<AuthService>();
  final ImagePicker _imagePicker = ImagePicker();

  // Observable properties
  final Rx<UserProfile?> _currentProfile = Rx<UserProfile?>(null);
  final RxList<ProfileActivity> _activities = <ProfileActivity>[].obs;
  final Rx<AvatarUpload?> _currentAvatarUpload = Rx<AvatarUpload?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isUpdatingProfile = false.obs;
  final RxBool _isUploadingAvatar = false.obs;

  // Getters
  UserProfile? get currentProfile => _currentProfile.value;
  List<ProfileActivity> get activities => _activities.toList();
  AvatarUpload? get currentAvatarUpload => _currentAvatarUpload.value;
  bool get isLoading => _isLoading.value;
  bool get isUpdatingProfile => _isUpdatingProfile.value;
  bool get isUploadingAvatar => _isUploadingAvatar.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadCurrentProfile();
  }

  /// Load current user profile
  Future<void> loadCurrentProfile() async {
    _isLoading.value = true;
    try {
      final response = await _networkService.get(
        '${AppConfig.apiBaseUrl}/profile',
      );

      if (response.isSuccess) {
        _currentProfile.value = UserProfile.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.loadProfileError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    _isUpdatingProfile.value = true;
    try {
      final response = await _networkService.put(
        '${AppConfig.apiBaseUrl}/profile',
        updates,
      );

      if (response.isSuccess) {
        _currentProfile.value = UserProfile.fromJson(response.data);
        _addActivity('profile_updated', 'Profile information updated');
        
        Get.snackbar(
          AppStrings.success,
          AppStrings.profileUpdatedSuccess,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.updateProfileError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isUpdatingProfile.value = false;
    }
    return false;
  }

  /// Update profile privacy settings
  Future<bool> updatePrivacySettings(ProfilePrivacySettings settings) async {
    try {
      final response = await _networkService.put(
        '${AppConfig.apiBaseUrl}/profile/privacy',
        settings.toJson(),
      );

      if (response.isSuccess) {
        final updatedSettings = ProfilePrivacySettings.fromJson(response.data);
        _currentProfile.value = _currentProfile.value?.copyWith(
          privacySettings: updatedSettings,
        );
        
        _addActivity('privacy_updated', 'Privacy settings updated');
        
        Get.snackbar(
          AppStrings.success,
          AppStrings.privacySettingsUpdated,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.updatePrivacySettingsError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return false;
  }

  /// Pick and upload avatar image
  Future<bool> pickAndUploadAvatar({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return await uploadAvatar(File(pickedFile.path));
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.pickImageError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return false;
  }

  /// Upload avatar image
  Future<bool> uploadAvatar(File imageFile) async {
    _isUploadingAvatar.value = true;
    try {
      // Create form data for file upload
      final fileName = path.basename(imageFile.path);
      final fileSize = await imageFile.length();
      
      // Create multipart request
      final response = await _networkService.uploadFile(
        '${AppConfig.apiBaseUrl}/profile/avatar',
        imageFile,
        fileName: fileName,
        fieldName: 'avatar',
      );

      if (response.isSuccess) {
        final avatarUpload = AvatarUpload.fromJson(response.data);
        _currentAvatarUpload.value = avatarUpload;
        
        // Update current profile with new avatar URL
        if (avatarUpload.status == UploadStatus.completed) {
          _currentProfile.value = _currentProfile.value?.copyWith(
            avatarUrl: avatarUpload.originalUrl,
          );
          
          _addActivity('avatar_changed', 'Profile photo updated');
          
          Get.snackbar(
            AppStrings.success,
            AppStrings.avatarUploadedSuccess,
            snackPosition: SnackPosition.TOP,
          );
        }
        return true;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.uploadAvatarError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isUploadingAvatar.value = false;
    }
    return false;
  }

  /// Remove avatar
  Future<bool> removeAvatar() async {
    try {
      final response = await _networkService.delete(
        '${AppConfig.apiBaseUrl}/profile/avatar',
      );

      if (response.isSuccess) {
        _currentProfile.value = _currentProfile.value?.copyWith(
          avatarUrl: null,
        );
        _currentAvatarUpload.value = null;
        
        _addActivity('avatar_removed', 'Profile photo removed');
        
        Get.snackbar(
          AppStrings.success,
          AppStrings.avatarRemovedSuccess,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.removeAvatarError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return false;
  }

  /// Update user status
  Future<bool> updateStatus(String status, {String? statusMessage}) async {
    try {
      final updates = {
        'status': status,
        if (statusMessage != null) 'status_message': statusMessage,
      };

      final response = await _networkService.put(
        '${AppConfig.apiBaseUrl}/profile/status',
        updates,
      );

      if (response.isSuccess) {
        _currentProfile.value = _currentProfile.value?.copyWith(
          status: status,
          statusMessage: statusMessage,
        );
        
        _addActivity('status_changed', 'Status updated to $status');
        return true;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.updateStatusError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return false;
  }

  /// Get profile activities
  Future<void> loadProfileActivities({int limit = 20}) async {
    try {
      final response = await _networkService.get(
        '${AppConfig.apiBaseUrl}/profile/activities',
        queryParams: {'limit': limit.toString()},
      );

      if (response.isSuccess) {
        final activities = (response.data as List)
            .map((json) => ProfileActivity.fromJson(json))
            .toList();
        _activities.assignAll(activities);
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.loadActivitiesError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Get user profile by ID
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _networkService.get(
        '${AppConfig.apiBaseUrl}/users/$userId/profile',
      );

      if (response.isSuccess) {
        return UserProfile.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.loadUserProfileError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return null;
  }

  /// Search users by username or email
  Future<List<UserProfile>> searchUsers(String query, {int limit = 20}) async {
    try {
      final response = await _networkService.get(
        '${AppConfig.apiBaseUrl}/users/search',
        queryParams: {
          'q': query,
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess) {
        return (response.data as List)
            .map((json) => UserProfile.fromJson(json))
            .toList();
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.searchUsersError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return [];
  }

  /// Deactivate account
  Future<bool> deactivateAccount() async {
    try {
      final response = await _networkService.put(
        '${AppConfig.apiBaseUrl}/profile/deactivate',
        {},
      );

      if (response.isSuccess) {
        _currentProfile.value = _currentProfile.value?.copyWith(
          isActive: false,
        );
        
        _addActivity('account_deactivated', 'Account deactivated');
        
        Get.snackbar(
          AppStrings.success,
          AppStrings.accountDeactivatedSuccess,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.deactivateAccountError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return false;
  }

  /// Delete account permanently
  Future<bool> deleteAccount() async {
    try {
      final response = await _networkService.delete(
        '${AppConfig.apiBaseUrl}/profile',
      );

      if (response.isSuccess) {
        // Clear local data and logout
        _currentProfile.value = null;
        _activities.clear();
        _currentAvatarUpload.value = null;
        
        await _authService.logout();
        
        Get.snackbar(
          AppStrings.success,
          AppStrings.accountDeletedSuccess,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.deleteAccountError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return false;
  }

  /// Export user data
  Future<Map<String, dynamic>?> exportUserData() async {
    try {
      final response = await _networkService.get(
        '${AppConfig.apiBaseUrl}/profile/export',
      );

      if (response.isSuccess) {
        Get.snackbar(
          AppStrings.success,
          AppStrings.dataExportSuccess,
          snackPosition: SnackPosition.TOP,
        );
        return response.data;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.exportDataError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return null;
  }

  /// Verify email
  Future<bool> verifyEmail(String verificationCode) async {
    try {
      final response = await _networkService.post(
        '${AppConfig.apiBaseUrl}/profile/verify-email',
        {'verification_code': verificationCode},
      );

      if (response.isSuccess) {
        _currentProfile.value = _currentProfile.value?.copyWith(
          isEmailVerified: true,
        );
        
        _addActivity('email_verified', 'Email address verified');
        
        Get.snackbar(
          AppStrings.success,
          AppStrings.emailVerifiedSuccess,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.verifyEmailError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return false;
  }

  /// Send email verification
  Future<bool> sendEmailVerification() async {
    try {
      final response = await _networkService.post(
        '${AppConfig.apiBaseUrl}/profile/send-email-verification',
        {},
      );

      if (response.isSuccess) {
        Get.snackbar(
          AppStrings.success,
          AppStrings.emailVerificationSent,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.sendEmailVerificationError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return false;
  }

  /// Add activity to local list
  void _addActivity(String action, String description) {
    final activity = ProfileActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _currentProfile.value?.id ?? '',
      action: action,
      description: description,
      createdAt: DateTime.now(),
    );
    _activities.insert(0, activity);
  }

  /// Get status display name
  String getStatusDisplayName(String? status) {
    switch (status) {
      case 'online':
        return AppStrings.online;
      case 'away':
        return AppStrings.away;
      case 'busy':
        return AppStrings.busy;
      case 'offline':
      default:
        return AppStrings.offline;
    }
  }

  /// Get status color
  String getStatusColor(String? status) {
    switch (status) {
      case 'online':
        return '#4CAF50'; // Green
      case 'away':
        return '#FF9800'; // Orange
      case 'busy':
        return '#F44336'; // Red
      case 'offline':
      default:
        return '#9E9E9E'; // Grey
    }
  }

  /// Format file size
  String formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Get time ago string
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Clear profile data
  void clearProfileData() {
    _currentProfile.value = null;
    _activities.clear();
    _currentAvatarUpload.value = null;
  }
}
