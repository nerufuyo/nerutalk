import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/models/profile_models.dart';

/// User profile page
/// Shows current user profile with edit capabilities
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
        actions: [
          Obx(() => controller.isEditing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: controller.toggleEditMode,
                      child: Text(AppStrings.cancel),
                    ),
                    TextButton(
                      onPressed: controller.isUpdatingProfile 
                          ? null 
                          : controller.saveProfile,
                      child: Text(AppStrings.save),
                    ),
                  ],
                )
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: controller.toggleEditMode,
                ),
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'privacy',
                child: Row(
                  children: [
                    const Icon(Icons.privacy_tip, size: 20),
                    const SizedBox(width: 8),
                    Text(AppStrings.privacySettings),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'activities',
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 20),
                    const SizedBox(width: 8),
                    Text(AppStrings.profileActivity),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.download, size: 20),
                    const SizedBox(width: 8),
                    Text(AppStrings.exportData),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'deactivate',
                child: Row(
                  children: [
                    const Icon(Icons.pause_circle, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Text(AppStrings.deactivateAccount),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_forever, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text(AppStrings.deleteAccount),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const LoadingIndicator();
        }

        final profile = controller.currentProfile;
        if (profile == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.profileNotFound,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshProfile,
                  child: Text(AppStrings.retry),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(profile),
                const SizedBox(height: 24),
                _buildProfileCompletion(profile),
                const SizedBox(height: 24),
                _buildBasicInfo(profile),
                const SizedBox(height: 24),
                _buildContactInfo(profile),
                const SizedBox(height: 24),
                _buildStatusSection(profile),
                const SizedBox(height: 24),
                _buildPrivacySettingsSection(profile),
                const SizedBox(height: 24),
                _buildVerificationSection(profile),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Build profile header with avatar and basic info
  Widget _buildProfileHeader(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: profile.avatarUrl != null
                      ? CachedNetworkImageProvider(profile.avatarUrl!)
                      : null,
                  child: profile.avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.primary,
                        )
                      : null,
                ),
                if (controller.isUploadingAvatar)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: controller.showAvatarOptions,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              profile.bestDisplayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (profile.bio != null) ...[
              const SizedBox(height: 8),
              Text(
                profile.bio!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: controller.getStatusColor(profile.status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  controller.getStatusDisplayName(profile.status),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build profile completion indicator
  Widget _buildProfileCompletion(UserProfile profile) {
    final percentage = controller.profileCompletionPercentage;
    
    if (percentage >= 100) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment_turned_in,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.profileCompletion,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.textSecondary.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage% ${AppStrings.complete}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build basic information section
  Widget _buildBasicInfo(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.basicInformation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: AppStrings.displayName,
              controller: controller.displayNameController,
              value: profile.displayName,
              icon: Icons.badge,
            ),
            const SizedBox(height: 12),
            _buildInfoField(
              label: AppStrings.firstName,
              controller: controller.firstNameController,
              value: profile.firstName,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            _buildInfoField(
              label: AppStrings.lastName,
              controller: controller.lastNameController,
              value: profile.lastName,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            _buildInfoField(
              label: AppStrings.bio,
              controller: controller.bioController,
              value: profile.bio,
              icon: Icons.info_outline,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _buildDateField(
              label: AppStrings.dateOfBirth,
              value: profile.dateOfBirth,
              onTap: controller.selectDateOfBirth,
            ),
          ],
        ),
      ),
    );
  }

  /// Build contact information section
  Widget _buildContactInfo(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_mail,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.contactInformation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: AppStrings.email,
              value: profile.email,
              icon: Icons.email,
              readOnly: true,
              suffix: profile.isEmailVerified
                  ? Icon(Icons.verified, color: Colors.green, size: 20)
                  : TextButton(
                      onPressed: controller.sendEmailVerification,
                      child: Text(AppStrings.verify),
                    ),
            ),
            const SizedBox(height: 12),
            _buildInfoField(
              label: AppStrings.phoneNumber,
              controller: controller.phoneController,
              value: profile.phoneNumber,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              suffix: profile.isPhoneVerified
                  ? Icon(Icons.verified, color: Colors.green, size: 20)
                  : null,
            ),
            const SizedBox(height: 12),
            _buildInfoField(
              label: AppStrings.location,
              controller: controller.locationController,
              value: profile.location,
              icon: Icons.location_on,
            ),
            const SizedBox(height: 12),
            _buildInfoField(
              label: AppStrings.website,
              controller: controller.websiteController,
              value: profile.website,
              icon: Icons.language,
              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ),
    );
  }

  /// Build status section
  Widget _buildStatusSection(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.mood,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.status,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusSelector(),
            const SizedBox(height: 12),
            _buildInfoField(
              label: AppStrings.statusMessage,
              controller: controller.statusMessageController,
              value: profile.statusMessage,
              icon: Icons.message,
              maxLines: 2,
              onSubmitted: (_) => controller.updateStatusMessage(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build status selector
  Widget _buildStatusSelector() {
    return Obx(() => Wrap(
      spacing: 8,
      children: ['online', 'away', 'busy', 'offline'].map((status) {
        final isSelected = controller.selectedStatus == status;
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: controller.getStatusColor(status),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(controller.getStatusDisplayName(status)),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              controller.updateStatus(status);
            }
          },
        );
      }).toList(),
    ));
  }

  /// Build privacy settings section
  Widget _buildPrivacySettingsSection(UserProfile profile) {
    return Obx(() => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: controller.togglePrivacySettings,
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppStrings.privacySettings,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    controller.showPrivacySettings
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                ],
              ),
            ),
            if (controller.showPrivacySettings) ...[
              const SizedBox(height: 16),
              _buildPrivacyToggle(
                AppStrings.showEmail,
                profile.privacySettings?.showEmail ?? false,
                'show_email',
              ),
              _buildPrivacyToggle(
                AppStrings.showPhoneNumber,
                profile.privacySettings?.showPhoneNumber ?? false,
                'show_phone_number',
              ),
              _buildPrivacyToggle(
                AppStrings.showLastSeen,
                profile.privacySettings?.showLastSeen ?? true,
                'show_last_seen',
              ),
              _buildPrivacyToggle(
                AppStrings.showOnlineStatus,
                profile.privacySettings?.showOnlineStatus ?? true,
                'show_online_status',
              ),
              _buildPrivacyToggle(
                AppStrings.allowFriendRequests,
                profile.privacySettings?.allowFriendRequests ?? true,
                'allow_friend_requests',
              ),
            ],
          ],
        ),
      ),
    ));
  }

  /// Build privacy toggle
  Widget _buildPrivacyToggle(String title, bool value, String setting) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: (newValue) => controller.updatePrivacySetting(setting, newValue),
      ),
    );
  }

  /// Build verification section
  Widget _buildVerificationSection(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified_user,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.accountVerification,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildVerificationItem(
              AppStrings.emailVerification,
              profile.isEmailVerified,
              onTap: profile.isEmailVerified ? null : controller.sendEmailVerification,
            ),
            _buildVerificationItem(
              AppStrings.phoneVerification,
              profile.isPhoneVerified,
            ),
          ],
        ),
      ),
    );
  }

  /// Build verification item
  Widget _buildVerificationItem(String title, bool isVerified, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isVerified ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isVerified ? Colors.green : AppColors.textSecondary,
      ),
      title: Text(title),
      trailing: !isVerified && onTap != null
          ? TextButton(
              onPressed: onTap,
              child: Text(AppStrings.verify),
            )
          : null,
    );
  }

  /// Build info field
  Widget _buildInfoField({
    required String label,
    TextEditingController? controller,
    String? value,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    Widget? suffix,
    Function(String)? onSubmitted,
  }) {
    return Obx(() {
      final isEditing = this.controller.isEditing && !readOnly;
      
      if (isEditing && controller != null) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            suffix: suffix,
            border: const OutlineInputBorder(),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          onSubmitted: onSubmitted,
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (suffix != null) ...[
                  const Spacer(),
                  suffix,
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value?.isNotEmpty == true ? value! : AppStrings.notProvided,
              style: TextStyle(
                fontSize: 16,
                color: value?.isNotEmpty == true 
                    ? AppColors.textPrimary 
                    : AppColors.textSecondary,
              ),
            ),
          ],
        );
      }
    });
  }

  /// Build date field
  Widget _buildDateField({
    required String label,
    DateTime? value,
    required VoidCallback onTap,
  }) {
    return Obx(() {
      final isEditing = controller.isEditing;
      final displayValue = value != null 
          ? '${value.day}/${value.month}/${value.year}'
          : AppStrings.notProvided;
      
      if (isEditing) {
        return InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: const Icon(Icons.calendar_today),
              border: const OutlineInputBorder(),
            ),
            child: Text(displayValue),
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              displayValue,
              style: TextStyle(
                fontSize: 16,
                color: value != null 
                    ? AppColors.textPrimary 
                    : AppColors.textSecondary,
              ),
            ),
          ],
        );
      }
    });
  }

  /// Handle menu actions
  void _handleMenuAction(String action) {
    switch (action) {
      case 'privacy':
        Get.toNamed('/privacy-settings');
        break;
      case 'activities':
        Get.toNamed('/profile-activities');
        break;
      case 'export':
        controller.exportUserData();
        break;
      case 'deactivate':
        controller.showDeactivateAccountConfirmation();
        break;
      case 'delete':
        controller.showDeleteAccountConfirmation();
        break;
    }
  }
}
