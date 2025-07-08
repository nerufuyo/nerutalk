import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Main settings page with navigation to different settings sections
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // App Settings Section
            _buildSectionHeader('app_settings'.tr),
            _buildSettingsTile(
              icon: Icons.language,
              title: 'language'.tr,
              subtitle: controller.getLanguageName(
                controller.selectedLanguage.value,
              ),
              onTap: () => _showLanguageDialog(context, controller),
            ),
            _buildSettingsTile(
              icon: Icons.palette,
              title: 'theme'.tr,
              subtitle: controller.getThemeName(controller.selectedTheme.value),
              onTap: () => _showThemeDialog(context, controller),
            ),
            _buildSettingsTile(
              icon: Icons.text_fields,
              title: 'font_size'.tr,
              subtitle: controller.getFontSizeName(
                controller.selectedFontSize.value,
              ),
              onTap: () => _showFontSizeDialog(context, controller),
            ),
            _buildSwitchTile(
              icon: Icons.animation,
              title: 'enable_animations'.tr,
              value: controller.enableAnimations.value,
              onChanged: (value) {
                controller.enableAnimations.value = value;
                controller.updateAppSettings();
              },
            ),
            _buildSwitchTile(
              icon: Icons.volume_up,
              title: 'enable_sounds'.tr,
              value: controller.enableSounds.value,
              onChanged: (value) {
                controller.enableSounds.value = value;
                controller.updateAppSettings();
              },
            ),
            _buildSwitchTile(
              icon: Icons.vibration,
              title: 'enable_vibration'.tr,
              value: controller.enableVibration.value,
              onChanged: (value) {
                controller.enableVibration.value = value;
                controller.updateAppSettings();
              },
            ),

            const SizedBox(height: 24),

            // Privacy & Security Section
            _buildSectionHeader('privacy_security'.tr),
            _buildSettingsTile(
              icon: Icons.privacy_tip,
              title: 'privacy'.tr,
              subtitle: 'privacy_settings_desc'.tr,
              onTap: () => Get.toNamed('/privacy'),
            ),
            _buildSettingsTile(
              icon: Icons.security,
              title: 'security'.tr,
              subtitle: 'security_settings_desc'.tr,
              onTap: () => Get.toNamed('/security'),
            ),
            _buildSettingsTile(
              icon: Icons.notifications,
              title: 'notifications'.tr,
              subtitle: 'notification_settings_desc'.tr,
              onTap: () => Get.toNamed('/notification-preferences'),
            ),

            const SizedBox(height: 24),

            // Data & Storage Section
            _buildSectionHeader('data_storage'.tr),
            _buildSettingsTile(
              icon: Icons.data_usage,
              title: 'data_usage'.tr,
              subtitle: controller.dataUsageMode.value.tr,
              onTap: () => _showDataUsageDialog(context, controller),
            ),
            _buildSettingsTile(
              icon: Icons.download,
              title: 'auto_download'.tr,
              subtitle: controller.enableAutoDownload.value
                  ? 'enabled'.tr
                  : 'disabled'.tr,
              onTap: () => _showAutoDownloadDialog(context, controller),
            ),
            _buildSettingsTile(
              icon: Icons.storage,
              title: 'storage'.tr,
              subtitle: 'manage_storage_desc'.tr,
              onTap: () => Get.toNamed('/storage'),
            ),

            const SizedBox(height: 24),

            // Account Section
            _buildSectionHeader('account'.tr),
            _buildSettingsTile(
              icon: Icons.account_circle,
              title: 'account_settings'.tr,
              subtitle: 'manage_account_desc'.tr,
              onTap: () => Get.toNamed('/account-settings'),
            ),
            _buildSettingsTile(
              icon: Icons.backup,
              title: 'backup_restore'.tr,
              subtitle: 'backup_restore_desc'.tr,
              onTap: () => Get.toNamed('/backup'),
            ),

            const SizedBox(height: 24),

            // Help & Support Section
            _buildSectionHeader('help_support'.tr),
            _buildSettingsTile(
              icon: Icons.help,
              title: 'help'.tr,
              subtitle: 'help_center_desc'.tr,
              onTap: () => Get.toNamed('/help'),
            ),
            _buildSettingsTile(
              icon: Icons.feedback,
              title: 'feedback'.tr,
              subtitle: 'send_feedback_desc'.tr,
              onTap: () => Get.toNamed('/feedback'),
            ),
            _buildSettingsTile(
              icon: Icons.info,
              title: 'about'.tr,
              subtitle: 'about_app_desc'.tr,
              onTap: () => Get.toNamed('/about'),
            ),

            const SizedBox(height: 24),

            // Logout
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'logout'.tr,
              subtitle: 'logout_desc'.tr,
              onTap: () => _showLogoutDialog(context),
              textColor: Colors.red,
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

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? AppColors.primary),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: textColor?.withOpacity(0.7) ?? Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    SettingsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_language'.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.languages.length,
            itemBuilder: (context, index) {
              final language = controller.languages[index];
              final isSelected =
                  language['code'] == controller.selectedLanguage.value;

              return ListTile(
                title: Text(language['name']!),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  controller.changeLanguage(language['code']!);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_theme'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.themes.map((theme) {
            final isSelected = theme['value'] == controller.selectedTheme.value;

            return ListTile(
              title: Text(theme['name']!),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                controller.changeTheme(theme['value']!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showFontSizeDialog(
    BuildContext context,
    SettingsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_font_size'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.fontSizes.map((fontSize) {
            final isSelected =
                fontSize['value'] == controller.selectedFontSize.value;

            return ListTile(
              title: Text(fontSize['name']!),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                controller.selectedFontSize.value = fontSize['value']!;
                controller.updateAppSettings();
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDataUsageDialog(
    BuildContext context,
    SettingsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('data_usage_mode'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.dataUsageModes.map((mode) {
            final isSelected = mode['value'] == controller.dataUsageMode.value;

            return ListTile(
              title: Text(mode['name']!),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                controller.dataUsageMode.value = mode['value']!;
                controller.updateAppSettings();
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAutoDownloadDialog(
    BuildContext context,
    SettingsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('auto_download'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('enable_auto_download'.tr),
              value: controller.enableAutoDownload.value,
              onChanged: (value) {
                controller.enableAutoDownload.value = value;
                controller.updateAppSettings();
              },
            ),
            if (controller.enableAutoDownload.value) ...[
              const Divider(),
              Text(
                'download_quality'.tr,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              ...controller.downloadQualities.map((quality) {
                final isSelected =
                    quality['value'] == controller.downloadQuality.value;

                return ListTile(
                  title: Text(quality['name']!),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    controller.downloadQuality.value = quality['value']!;
                    controller.updateAppSettings();
                  },
                );
              }).toList(),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('done'.tr),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('confirm_logout'.tr),
        content: Text('logout_confirmation'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<SettingsController>().logout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}
