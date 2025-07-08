import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_colors.dart';

/// Privacy settings page for managing user privacy preferences
class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('privacy'.tr),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => controller.updatePrivacySettings(),
            child: Text(
              'save'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Visibility
            _buildSectionHeader('profile_visibility'.tr),
            _buildSwitchTile(
              title: 'show_profile_photo'.tr,
              subtitle: 'profile_photo_visibility_desc'.tr,
              value: controller.showProfilePhoto.value,
              onChanged: (value) => controller.showProfilePhoto.value = value,
            ),
            _buildSwitchTile(
              title: 'show_about'.tr,
              subtitle: 'about_visibility_desc'.tr,
              value: controller.showAbout.value,
              onChanged: (value) => controller.showAbout.value = value,
            ),
            _buildSwitchTile(
              title: 'show_phone_number'.tr,
              subtitle: 'phone_visibility_desc'.tr,
              value: controller.showPhoneNumber.value,
              onChanged: (value) => controller.showPhoneNumber.value = value,
            ),

            const SizedBox(height: 24),

            // Online Status
            _buildSectionHeader('online_status'.tr),
            _buildSwitchTile(
              title: 'show_last_seen'.tr,
              subtitle: 'last_seen_visibility_desc'.tr,
              value: controller.showLastSeen.value,
              onChanged: (value) => controller.showLastSeen.value = value,
            ),
            _buildSwitchTile(
              title: 'show_online_status'.tr,
              subtitle: 'online_status_visibility_desc'.tr,
              value: controller.showOnlineStatus.value,
              onChanged: (value) => controller.showOnlineStatus.value = value,
            ),

            const SizedBox(height: 24),

            // Communication
            _buildSectionHeader('communication'.tr),
            _buildDropdownTile(
              title: 'who_can_call_me'.tr,
              subtitle: 'call_privacy_desc'.tr,
              value: controller.whoCanCallMe.value,
              options: controller.privacyOptions,
              onChanged: (value) => controller.whoCanCallMe.value = value,
            ),
            _buildDropdownTile(
              title: 'who_can_add_me_to_groups'.tr,
              subtitle: 'group_privacy_desc'.tr,
              value: controller.whoCanAddMeToGroups.value,
              options: controller.privacyOptions,
              onChanged: (value) => controller.whoCanAddMeToGroups.value = value,
            ),
            _buildDropdownTile(
              title: 'who_can_see_my_story'.tr,
              subtitle: 'story_privacy_desc'.tr,
              value: controller.whoCanSeeMyStory.value,
              options: controller.privacyOptions,
              onChanged: (value) => controller.whoCanSeeMyStory.value = value,
            ),

            const SizedBox(height: 24),

            // Contact Requests
            _buildSectionHeader('contact_requests'.tr),
            _buildSwitchTile(
              title: 'allow_contacts_to_add_me'.tr,
              subtitle: 'contacts_add_desc'.tr,
              value: controller.allowContactsToAddMe.value,
              onChanged: (value) => controller.allowContactsToAddMe.value = value,
            ),
            _buildSwitchTile(
              title: 'allow_strangers_to_add_me'.tr,
              subtitle: 'strangers_add_desc'.tr,
              value: controller.allowStrangersToAddMe.value,
              onChanged: (value) => controller.allowStrangersToAddMe.value = value,
            ),
            _buildSwitchTile(
              title: 'allow_group_invites'.tr,
              subtitle: 'group_invites_desc'.tr,
              value: controller.allowGroupInvites.value,
              onChanged: (value) => controller.allowGroupInvites.value = value,
            ),

            const SizedBox(height: 24),

            // Messages
            _buildSectionHeader('messages'.tr),
            _buildSwitchTile(
              title: 'read_receipts'.tr,
              subtitle: 'read_receipts_desc'.tr,
              value: controller.readReceipts.value,
              onChanged: (value) => controller.readReceipts.value = value,
            ),
            _buildSwitchTile(
              title: 'typing_indicators'.tr,
              subtitle: 'typing_indicators_desc'.tr,
              value: controller.typingIndicators.value,
              onChanged: (value) => controller.typingIndicators.value = value,
            ),

            const SizedBox(height: 24),

            // Blocked Users
            _buildSectionHeader('blocked_users'.tr),
            Card(
              child: ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: Text('blocked_users'.tr),
                subtitle: Text(
                  controller.blockedUsers.isEmpty 
                      ? 'no_blocked_users'.tr 
                      : '${controller.blockedUsers.length} blocked_users_count'.tr,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showBlockedUsersDialog(context, controller),
              ),
            ),

            const SizedBox(height: 32),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600]),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<Map<String, String>> options,
    required ValueChanged<String> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              _getOptionName(value, options),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: () => _showOptionsDialog(title, value, options, onChanged),
      ),
    );
  }

  String _getOptionName(String value, List<Map<String, String>> options) {
    final option = options.firstWhere(
      (opt) => opt['value'] == value,
      orElse: () => {'name': value},
    );
    return option['name']!.tr;
  }

  void _showOptionsDialog(
    String title,
    String currentValue,
    List<Map<String, String>> options,
    ValueChanged<String> onChanged,
  ) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final isSelected = option['value'] == currentValue;
            
            return ListTile(
              title: Text(option['name']!.tr),
              trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                onChanged(option['value']!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showBlockedUsersDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('blocked_users'.tr),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: controller.blockedUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.block,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_blocked_users'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.blockedUsers.length,
                  itemBuilder: (context, index) {
                    final userId = controller.blockedUsers[index];
                    
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(userId.substring(0, 1).toUpperCase()),
                      ),
                      title: Text('User $userId'), // In real app, fetch user name
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => controller.unblockUser(userId),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }
}
