import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/models/settings_models.dart';

/// Security settings page for managing security preferences
class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('security'.tr),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => controller.updateSecuritySettings(),
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
            // Authentication
            _buildSectionHeader('authentication'.tr),
            _buildSwitchTile(
              icon: Icons.fingerprint,
              title: 'biometric_auth'.tr,
              subtitle: 'biometric_auth_desc'.tr,
              value: controller.biometricAuth.value,
              onChanged: (value) => controller.biometricAuth.value = value,
            ),
            _buildSwitchTile(
              icon: Icons.security,
              title: 'two_factor_auth'.tr,
              subtitle: 'two_factor_auth_desc'.tr,
              value: controller.twoFactorAuth.value,
              onChanged: (value) => controller.toggleTwoFactorAuth(),
            ),

            const SizedBox(height: 24),

            // Screen Lock
            _buildSectionHeader('screen_lock'.tr),
            _buildSwitchTile(
              icon: Icons.lock_clock,
              title: 'screen_lock'.tr,
              subtitle: 'screen_lock_desc'.tr,
              value: controller.screenLock.value,
              onChanged: (value) => controller.screenLock.value = value,
            ),
            if (controller.screenLock.value)
              _buildDropdownTile(
                icon: Icons.timer,
                title: 'lock_timeout'.tr,
                subtitle: 'lock_timeout_desc'.tr,
                value: controller.lockTimeout.value,
                options: controller.lockTimeouts,
                onChanged: (value) => controller.lockTimeout.value = value,
                displayText: _getLockTimeoutText(controller.lockTimeout.value),
              ),

            const SizedBox(height: 24),

            // Privacy Features
            _buildSectionHeader('privacy_features'.tr),
            _buildSwitchTile(
              icon: Icons.keyboard_hide,
              title: 'incognito_keyboard'.tr,
              subtitle: 'incognito_keyboard_desc'.tr,
              value: controller.incognitoKeyboard.value,
              onChanged: (value) => controller.incognitoKeyboard.value = value,
            ),
            _buildSwitchTile(
              icon: Icons.notifications_active,
              title: 'security_notifications'.tr,
              subtitle: 'security_notifications_desc'.tr,
              value: controller.showSecurityNotifications.value,
              onChanged: (value) => controller.showSecurityNotifications.value = value,
            ),
            _buildSwitchTile(
              icon: Icons.verified_user,
              title: 'require_auth_for_sensitive'.tr,
              subtitle: 'require_auth_desc'.tr,
              value: controller.requireAuthForSensitiveActions.value,
              onChanged: (value) => controller.requireAuthForSensitiveActions.value = value,
            ),

            const SizedBox(height: 24),

            // Password & Recovery
            _buildSectionHeader('password_recovery'.tr),
            _buildActionTile(
              icon: Icons.password,
              title: 'change_password'.tr,
              subtitle: 'change_password_desc'.tr,
              onTap: () => _showChangePasswordDialog(context, controller),
            ),

            const SizedBox(height: 24),

            // Device Management
            _buildSectionHeader('device_management'.tr),
            _buildActionTile(
              icon: Icons.devices,
              title: 'trusted_devices'.tr,
              subtitle: controller.trustedDevices.isEmpty 
                  ? 'no_trusted_devices'.tr 
                  : '${controller.trustedDevices.length} trusted_devices_count'.tr,
              onTap: () => _showTrustedDevicesDialog(context, controller),
            ),
            _buildActionTile(
              icon: Icons.history,
              title: 'security_logs'.tr,
              subtitle: 'view_security_activity'.tr,
              onTap: () => _showSecurityLogsDialog(context, controller),
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
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
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
    required IconData icon,
    required String title,
    required String subtitle,
    required int value,
    required List<Map<String, dynamic>> options,
    required ValueChanged<int> onChanged,
    required String displayText,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
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
              displayText,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: () => _showLockTimeoutDialog(options, value, onChanged),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  String _getLockTimeoutText(int minutes) {
    if (minutes == 0) return 'never'.tr;
    if (minutes == 1) return '1_minute'.tr;
    if (minutes < 60) return '$minutes minutes'.tr;
    if (minutes == 60) return '1_hour'.tr;
    return '${minutes ~/ 60} hours'.tr;
  }

  void _showLockTimeoutDialog(
    List<Map<String, dynamic>> options,
    int currentValue,
    ValueChanged<int> onChanged,
  ) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('lock_timeout'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final isSelected = option['value'] == currentValue;
            
            return ListTile(
              title: Text(option['name']),
              trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                onChanged(option['value']);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, SettingsController controller) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('change_password'.tr),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'current_password'.tr,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'current_password_required'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'new_password'.tr,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'new_password_required'.tr;
                  }
                  if (value.length < 8) {
                    return 'password_too_short'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'confirm_new_password'.tr,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'passwords_do_not_match'.tr;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                controller.changePassword(
                  currentPasswordController.text,
                  newPasswordController.text,
                );
                Navigator.pop(context);
              }
            },
            child: Text('change_password'.tr),
          ),
        ],
      ),
    );
  }

  void _showTrustedDevicesDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('trusted_devices'.tr),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: controller.trustedDevices.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.devices,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_trusted_devices'.tr,
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
                  itemCount: controller.trustedDevices.length,
                  itemBuilder: (context, index) {
                    final deviceId = controller.trustedDevices[index];
                    
                    return ListTile(
                      leading: const Icon(Icons.phone_android),
                      title: Text('Device $deviceId'), // In real app, show device name
                      subtitle: Text('added_on'.tr + ': ' + DateTime.now().toString().split(' ')[0]),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          // Remove device from trusted list
                          controller.trustedDevices.remove(deviceId);
                        },
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

  void _showSecurityLogsDialog(BuildContext context, SettingsController controller) {
    controller.loadSecurityLogs();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('security_logs'.tr),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Obx(() {
            if (controller.securityLogs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.history,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'no_security_logs'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.securityLogs.length,
              itemBuilder: (context, index) {
                final log = controller.securityLogs[index];
                
                return ListTile(
                  leading: _getSecurityLogIcon(log.action),
                  title: Text(_getSecurityLogTitle(log.action)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(log.deviceInfo),
                      Text(
                        _formatDateTime(log.timestamp),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            );
          }),
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

  Widget _getSecurityLogIcon(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return const Icon(Icons.login, color: Colors.green);
      case 'logout':
        return const Icon(Icons.logout, color: Colors.orange);
      case 'password_change':
        return const Icon(Icons.password, color: Colors.blue);
      case 'failed_login':
        return const Icon(Icons.error, color: Colors.red);
      default:
        return const Icon(Icons.info, color: Colors.grey);
    }
  }

  String _getSecurityLogTitle(String action) {
    return action.replaceAll('_', ' ').capitalize ?? action;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago'.tr;
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago'.tr;
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago'.tr;
    } else {
      return 'just_now'.tr;
    }
  }
}
