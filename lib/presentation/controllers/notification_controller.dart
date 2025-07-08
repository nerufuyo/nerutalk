import 'package:get/get.dart';
import '../../core/services/notification_service.dart';
import '../../domain/models/notification_models.dart';

/// Notification controller for managing push notifications UI
class NotificationController extends GetxController {
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  // Observable properties
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingStats = false.obs;
  final RxBool _isLoadingPreferences = false.obs;
  final Rx<Map<String, dynamic>?> _stats = Rx<Map<String, dynamic>?>(null);
  final RxString _selectedStatsType = 'all'.obs;
  final Rx<DateTime> _statsStartDate = DateTime.now()
      .subtract(const Duration(days: 30))
      .obs;
  final Rx<DateTime> _statsEndDate = DateTime.now().obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingStats => _isLoadingStats.value;
  bool get isLoadingPreferences => _isLoadingPreferences.value;
  Map<String, dynamic>? get stats => _stats.value;
  String get selectedStatsType => _selectedStatsType.value;
  DateTime get statsStartDate => _statsStartDate.value;
  DateTime get statsEndDate => _statsEndDate.value;

  // Notification service getters
  List<DeviceToken> get deviceTokens =>
      _notificationService.deviceTokens.toList();
  List<PushNotification> get notifications =>
      _notificationService.notifications.toList();
  NotificationPreferences get preferences =>
      _notificationService.preferences.value;
  String? get fcmToken => _notificationService.fcmToken.value;
  bool get isInitialized => _notificationService.isInitialized.value;
  int get unreadCount => _notificationService.unreadCount.value;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  /// Load initial data
  Future<void> _loadInitialData() async {
    _isLoading.value = true;
    try {
      await Future.wait([
        _notificationService.getUserDeviceTokens(),
        _notificationService.getNotificationPreferences(),
        loadNotificationStats(),
      ]);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    await _loadInitialData();
  }

  /// Load notification statistics
  Future<void> loadNotificationStats() async {
    _isLoadingStats.value = true;
    try {
      final statsData = await _notificationService.getNotificationStats(
        startDate: _statsStartDate.value,
        endDate: _statsEndDate.value,
        type: _selectedStatsType.value == 'all'
            ? 'all'
            : _selectedStatsType.value,
      );
      _stats.value = statsData;
    } finally {
      _isLoadingStats.value = false;
    }
  }

  /// Update stats filter
  void updateStatsFilter({
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (type != null) _selectedStatsType.value = type;
    if (startDate != null) _statsStartDate.value = startDate;
    if (endDate != null) _statsEndDate.value = endDate;
    loadNotificationStats();
  }

  /// Update device token status
  Future<void> updateDeviceTokenStatus(String tokenId, bool isActive) async {
    await _notificationService.updateDeviceToken(
      token: tokenId,
      deviceType: 'unknown',
      deviceId: 'unknown',
    );
  }

  /// Remove device token
  Future<void> removeDeviceToken(String tokenId) async {
    await _notificationService.removeDeviceToken(tokenId);
  }

  /// Send test notification
  Future<void> sendTestNotification() async {
    final notification = PushNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Test Notification',
      body: 'This is a test notification from NeruTalk',
      recipientUserIds: [], // Will be filled by backend with current user
      type: 'system',
      priority: 'normal',
      createdAt: DateTime.now(),
    );
    await _notificationService.sendNotification(notification);
  }

  /// Send notification to specific users
  Future<void> sendNotificationToUsers({
    required String title,
    required String body,
    required List<String> userIds,
    String type = 'system',
    String priority = 'normal',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    final notification = PushNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      recipientUserIds: userIds,
      type: type,
      priority: priority,
      data: data,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    await _notificationService.sendNotification(notification);
  }

  /// Broadcast notification to all users
  Future<void> broadcastNotification({
    required String title,
    required String body,
    String type = 'broadcast',
    String priority = 'normal',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    await _notificationService.broadcastNotification(
      title: title,
      body: body,
      data: data,
    );
  }

  /// Update notification preferences
  Future<void> updateNotificationPreferences(
    NotificationPreferences preferences,
  ) async {
    _isLoadingPreferences.value = true;
    try {
      await _notificationService.updateNotificationPreferences(preferences);
    } finally {
      _isLoadingPreferences.value = false;
    }
  }

  /// Toggle notification type
  Future<void> toggleNotificationType(String type, bool enabled) async {
    final currentPrefs = preferences;
    NotificationPreferences updatedPrefs;

    switch (type) {
      case 'push':
        updatedPrefs = currentPrefs.copyWith(enablePush: enabled);
        break;
      case 'chat':
        updatedPrefs = currentPrefs.copyWith(enableChat: enabled);
        break;
      case 'calls':
        updatedPrefs = currentPrefs.copyWith(enableCalls: enabled);
        break;
      case 'system':
        updatedPrefs = currentPrefs.copyWith(enableSystem: enabled);
        break;
      case 'broadcast':
        updatedPrefs = currentPrefs.copyWith(enableBroadcast: enabled);
        break;
      case 'sound':
        updatedPrefs = currentPrefs.copyWith(enableSound: enabled);
        break;
      case 'vibration':
        updatedPrefs = currentPrefs.copyWith(enableVibration: enabled);
        break;
      case 'quiet_hours':
        updatedPrefs = currentPrefs.copyWith(enableQuietHours: enabled);
        break;
      default:
        return;
    }

    await updateNotificationPreferences(updatedPrefs);
  }

  /// Update quiet hours
  Future<void> updateQuietHours(String startTime, String endTime) async {
    final updatedPrefs = preferences.copyWith(
      quietHoursStart: startTime,
      quietHoursEnd: endTime,
    );
    await updateNotificationPreferences(updatedPrefs);
  }

  /// Clear all notifications
  void clearAllNotifications() {
    _notificationService.clearNotifications();
  }

  /// Clear specific notification
  void clearNotification(String id) {
    _notificationService.clearNotification(id);
  }

  /// Get notification type display name
  String getNotificationTypeDisplayName(String type) {
    switch (type) {
      case 'chat':
        return 'Chat Messages';
      case 'call':
        return 'Video Calls';
      case 'system':
        return 'System';
      case 'broadcast':
        return 'Announcements';
      default:
        return type.toUpperCase();
    }
  }

  /// Get notification priority display name
  String getNotificationPriorityDisplayName(String priority) {
    switch (priority) {
      case 'low':
        return 'Low Priority';
      case 'normal':
        return 'Normal Priority';
      case 'high':
        return 'High Priority';
      default:
        return priority.toUpperCase();
    }
  }

  /// Get device type icon
  String getDeviceTypeIcon(String deviceType) {
    switch (deviceType) {
      case 'android':
        return '🤖';
      case 'ios':
        return '📱';
      case 'web':
        return '🌐';
      default:
        return '📱';
    }
  }

  /// Format notification stats
  String formatStatsValue(dynamic value) {
    if (value is int) {
      if (value >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}M';
      } else if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(1)}K';
      }
      return value.toString();
    } else if (value is double) {
      return '${(value * 100).toStringAsFixed(1)}%';
    }
    return value.toString();
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
}
