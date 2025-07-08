import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';

/// Notification preferences page
/// Allows users to configure their notification settings
class NotificationPreferencesPage extends GetView<NotificationController> {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notificationPreferences),
      ),
      body: Obx(() {
        if (controller.isLoadingPreferences) {
          return const LoadingIndicator();
        }

        final preferences = controller.preferences;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationTypesSection(preferences),
              const SizedBox(height: 24),
              _buildSoundAndVibrationSection(preferences),
              const SizedBox(height: 24),
              _buildQuietHoursSection(preferences),
              const SizedBox(height: 24),
              _buildDeviceInfoSection(),
            ],
          ),
        );
      }),
    );
  }

  /// Build notification types section
  Widget _buildNotificationTypesSection(preferences) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.notificationTypes,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationToggle(
              title: AppStrings.enablePushNotifications,
              subtitle: AppStrings.enablePushNotificationsSubtitle,
              value: preferences.enablePush,
              onChanged: (value) => controller.toggleNotificationType('push', value),
              icon: Icons.push_pin,
            ),
            const Divider(),
            _buildNotificationToggle(
              title: AppStrings.chatNotifications,
              subtitle: AppStrings.chatNotificationsSubtitle,
              value: preferences.enableChat,
              onChanged: (value) => controller.toggleNotificationType('chat', value),
              icon: Icons.chat,
              enabled: preferences.enablePush,
            ),
            const Divider(),
            _buildNotificationToggle(
              title: AppStrings.callNotifications,
              subtitle: AppStrings.callNotificationsSubtitle,
              value: preferences.enableCalls,
              onChanged: (value) => controller.toggleNotificationType('calls', value),
              icon: Icons.videocam,
              enabled: preferences.enablePush,
            ),
            const Divider(),
            _buildNotificationToggle(
              title: AppStrings.systemNotifications,
              subtitle: AppStrings.systemNotificationsSubtitle,
              value: preferences.enableSystem,
              onChanged: (value) => controller.toggleNotificationType('system', value),
              icon: Icons.settings,
              enabled: preferences.enablePush,
            ),
            const Divider(),
            _buildNotificationToggle(
              title: AppStrings.broadcastNotifications,
              subtitle: AppStrings.broadcastNotificationsSubtitle,
              value: preferences.enableBroadcast,
              onChanged: (value) => controller.toggleNotificationType('broadcast', value),
              icon: Icons.campaign,
              enabled: preferences.enablePush,
            ),
          ],
        ),
      ),
    );
  }

  /// Build sound and vibration section
  Widget _buildSoundAndVibrationSection(preferences) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.volume_up,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.soundAndVibration,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationToggle(
              title: AppStrings.enableSound,
              subtitle: AppStrings.enableSoundSubtitle,
              value: preferences.enableSound,
              onChanged: (value) => controller.toggleNotificationType('sound', value),
              icon: Icons.volume_up,
              enabled: preferences.enablePush,
            ),
            const Divider(),
            _buildNotificationToggle(
              title: AppStrings.enableVibration,
              subtitle: AppStrings.enableVibrationSubtitle,
              value: preferences.enableVibration,
              onChanged: (value) => controller.toggleNotificationType('vibration', value),
              icon: Icons.vibration,
              enabled: preferences.enablePush,
            ),
          ],
        ),
      ),
    );
  }

  /// Build quiet hours section
  Widget _buildQuietHoursSection(preferences) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bedtime,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.quietHours,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationToggle(
              title: AppStrings.enableQuietHours,
              subtitle: AppStrings.enableQuietHoursSubtitle,
              value: preferences.enableQuietHours,
              onChanged: (value) => controller.toggleNotificationType('quiet_hours', value),
              icon: Icons.bedtime,
              enabled: preferences.enablePush,
            ),
            if (preferences.enableQuietHours) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeSelector(
                      label: AppStrings.startTime,
                      time: preferences.quietHoursStart,
                      onTimeSelected: (time) => _updateQuietHours(
                        time,
                        preferences.quietHoursEnd,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimeSelector(
                      label: AppStrings.endTime,
                      time: preferences.quietHoursEnd,
                      onTimeSelected: (time) => _updateQuietHours(
                        preferences.quietHoursStart,
                        time,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build device info section
  Widget _buildDeviceInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.deviceInformation,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              AppStrings.fcmToken,
              controller.fcmToken ?? AppStrings.notAvailable,
              Icons.token,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              AppStrings.notificationStatus,
              controller.isInitialized 
                  ? AppStrings.initialized
                  : AppStrings.notInitialized,
              Icons.check_circle,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              AppStrings.registeredDevices,
              controller.deviceTokens.length.toString(),
              Icons.devices,
            ),
          ],
        ),
      ),
    );
  }

  /// Build notification toggle
  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    bool enabled = true,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: enabled ? AppColors.primary : AppColors.textSecondary,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: enabled ? value : false,
        onChanged: enabled ? onChanged : null,
        activeColor: AppColors.primary,
      ),
    );
  }

  /// Build time selector
  Widget _buildTimeSelector({
    required String label,
    required String time,
    required Function(String) onTimeSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showTimePicker(time, onTimeSelected),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textSecondary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.access_time,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Show time picker
  void _showTimePicker(String currentTime, Function(String) onTimeSelected) {
    final timeParts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    showTimePicker(
      context: Get.context!,
      initialTime: initialTime,
    ).then((selectedTime) {
      if (selectedTime != null) {
        final formattedTime = 
            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
        onTimeSelected(formattedTime);
      }
    });
  }

  /// Update quiet hours
  void _updateQuietHours(String startTime, String endTime) {
    controller.updateQuietHours(startTime, endTime);
  }
}
