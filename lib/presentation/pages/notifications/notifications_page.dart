import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/models/notification_models.dart';

/// Notifications management page
/// Shows notification history, device tokens, and statistics
class NotificationsPage extends GetView<NotificationController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notifications),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'test',
                child: Row(
                  children: [
                    const Icon(Icons.send, size: 20),
                    const SizedBox(width: 8),
                    Text(AppStrings.sendTestNotification),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    const Icon(Icons.clear_all, size: 20),
                    const SizedBox(width: 8),
                    Text(AppStrings.clearAllNotifications),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'preferences',
                child: Row(
                  children: [
                    const Icon(Icons.settings, size: 20),
                    const SizedBox(width: 8),
                    Text(AppStrings.notificationPreferences),
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

        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: AppStrings.notificationHistory),
                  Tab(text: AppStrings.deviceTokens),
                  Tab(text: AppStrings.statistics),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildNotificationHistory(),
                    _buildDeviceTokens(),
                    _buildStatistics(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSendNotificationDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build notification history tab
  Widget _buildNotificationHistory() {
    return Obx(() {
      final notifications = controller.notifications;

      if (notifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.noNotificationsYet,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification);
          },
        ),
      );
    });
  }

  /// Build notification card
  Widget _buildNotificationCard(PushNotification notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationTypeColor(notification.type),
          child: Icon(
            _getNotificationTypeIcon(notification.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.body),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getNotificationTypeColor(notification.type),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.getNotificationTypeDisplayName(notification.type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  controller.getTimeAgo(notification.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleNotificationAction(action, notification),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build device tokens tab
  Widget _buildDeviceTokens() {
    return Obx(() {
      final tokens = controller.deviceTokens;

      if (tokens.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.devices,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.noDeviceTokens,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tokens.length,
        itemBuilder: (context, index) {
          final token = tokens[index];
          return _buildDeviceTokenCard(token);
        },
      );
    });
  }

  /// Build device token card
  Widget _buildDeviceTokenCard(DeviceToken token) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Text(
          controller.getDeviceTypeIcon(token.deviceType),
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          '${token.deviceType.toUpperCase()} Device',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('App Version: ${token.appVersion}'),
            const SizedBox(height: 4),
            Text('Created: ${controller.getTimeAgo(token.createdAt)}'),
            if (token.lastUsedAt != null) ...[
              const SizedBox(height: 4),
              Text('Last Used: ${controller.getTimeAgo(token.lastUsedAt!)}'),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: token.isActive,
              onChanged: (value) => controller.updateDeviceTokenStatus(token.id, value),
            ),
            PopupMenuButton<String>(
              onSelected: (action) => _handleTokenAction(action, token),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20),
                      SizedBox(width: 8),
                      Text('Remove'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build statistics tab
  Widget _buildStatistics() {
    return Obx(() {
      if (controller.isLoadingStats) {
        return const LoadingIndicator();
      }

      final stats = controller.stats;
      if (stats == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.noStatisticsAvailable,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsFilters(),
            const SizedBox(height: 20),
            _buildStatsCards(stats),
          ],
        ),
      );
    });
  }

  /// Build statistics filters
  Widget _buildStatsFilters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.filters,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                'all',
                'chat',
                'call',
                'system',
                'broadcast',
              ].map((type) {
                return Obx(() {
                  final isSelected = controller.selectedStatsType == type;
                  return FilterChip(
                    label: Text(type == 'all' ? 'All' : controller.getNotificationTypeDisplayName(type)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        controller.updateStatsFilter(type: type);
                      }
                    },
                  );
                });
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build statistics cards
  Widget _buildStatsCards(Map<String, dynamic> stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Sent',
                controller.formatStatsValue(stats['total_sent'] ?? 0),
                Icons.send,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Delivered',
                controller.formatStatsValue(stats['delivered'] ?? 0),
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Failed',
                controller.formatStatsValue(stats['failed'] ?? 0),
                Icons.error,
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Clicked',
                controller.formatStatsValue(stats['clicked'] ?? 0),
                Icons.touch_app,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Delivery Rate',
                controller.formatStatsValue(stats['delivery_rate'] ?? 0.0),
                Icons.trending_up,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Click Rate',
                controller.formatStatsValue(stats['click_rate'] ?? 0.0),
                Icons.mouse,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build stat card
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show send notification dialog
  void _showSendNotificationDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final userIdsController = TextEditingController();
    String selectedType = 'system';
    String selectedPriority = 'normal';

    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.sendNotification),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: AppStrings.notificationTitle,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(
                  labelText: AppStrings.notificationBody,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: userIdsController,
                decoration: InputDecoration(
                  labelText: AppStrings.recipientUserIds,
                  hintText: 'user1,user2,user3',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: AppStrings.notificationType,
                  border: const OutlineInputBorder(),
                ),
                items: ['system', 'chat', 'call', 'broadcast']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(controller.getNotificationTypeDisplayName(type)),
                        ))
                    .toList(),
                onChanged: (value) => selectedType = value!,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: InputDecoration(
                  labelText: AppStrings.priority,
                  border: const OutlineInputBorder(),
                ),
                items: ['low', 'normal', 'high']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(controller.getNotificationPriorityDisplayName(priority)),
                        ))
                    .toList(),
                onChanged: (value) => selectedPriority = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final userIds = userIdsController.text
                  .split(',')
                  .map((id) => id.trim())
                  .where((id) => id.isNotEmpty)
                  .toList();

              if (titleController.text.isNotEmpty && bodyController.text.isNotEmpty) {
                if (userIds.isEmpty) {
                  controller.broadcastNotification(
                    title: titleController.text,
                    body: bodyController.text,
                    type: selectedType,
                    priority: selectedPriority,
                  );
                } else {
                  controller.sendNotificationToUsers(
                    title: titleController.text,
                    body: bodyController.text,
                    userIds: userIds,
                    type: selectedType,
                    priority: selectedPriority,
                  );
                }
                Get.back();
              }
            },
            child: Text(AppStrings.send),
          ),
        ],
      ),
    );
  }

  /// Handle menu actions
  void _handleMenuAction(String action) {
    switch (action) {
      case 'test':
        controller.sendTestNotification();
        break;
      case 'clear':
        _showClearConfirmationDialog();
        break;
      case 'preferences':
        Get.toNamed('/notification-preferences');
        break;
    }
  }

  /// Handle notification actions
  void _handleNotificationAction(String action, PushNotification notification) {
    switch (action) {
      case 'delete':
        controller.clearNotification(notification.id);
        break;
    }
  }

  /// Handle token actions
  void _handleTokenAction(String action, DeviceToken token) {
    switch (action) {
      case 'remove':
        _showRemoveTokenConfirmationDialog(token);
        break;
    }
  }

  /// Show clear confirmation dialog
  void _showClearConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.clearAllNotifications),
        content: Text(AppStrings.clearAllNotificationsConfirmation),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearAllNotifications();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppStrings.clear),
          ),
        ],
      ),
    );
  }

  /// Show remove token confirmation dialog
  void _showRemoveTokenConfirmationDialog(DeviceToken token) {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.removeDeviceToken),
        content: Text(AppStrings.removeDeviceTokenConfirmation),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeDeviceToken(token.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppStrings.remove),
          ),
        ],
      ),
    );
  }

  /// Get notification type color
  Color _getNotificationTypeColor(String type) {
    switch (type) {
      case 'chat':
        return Colors.blue;
      case 'call':
        return Colors.green;
      case 'system':
        return Colors.orange;
      case 'broadcast':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  /// Get notification type icon
  IconData _getNotificationTypeIcon(String type) {
    switch (type) {
      case 'chat':
        return Icons.chat;
      case 'call':
        return Icons.videocam;
      case 'system':
        return Icons.settings;
      case 'broadcast':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }
}
