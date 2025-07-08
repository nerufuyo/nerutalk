import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../config/app_config.dart';
import '../constants/app_strings.dart';
import '../../domain/models/notification_models.dart';
import 'network_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Firebase Cloud Messaging and Push Notification Service
/// Handles FCM token management, local notifications, and backend communication
class NotificationService extends GetxService {
  static NotificationService get to => Get.find();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final NetworkService _networkService = Get.find<NetworkService>();

  // Observable properties
  final Rx<String?> _fcmToken = Rx<String?>(null);
  final RxList<DeviceToken> _deviceTokens = <DeviceToken>[].obs;
  final RxList<PushNotification> _notifications = <PushNotification>[].obs;
  final Rx<NotificationPreferences> _preferences = 
      const NotificationPreferences(userId: '').obs;
  final RxBool _isInitialized = false.obs;

  // Getters
  String? get fcmToken => _fcmToken.value;
  List<DeviceToken> get deviceTokens => _deviceTokens.toList();
  List<PushNotification> get notifications => _notifications.toList();
  NotificationPreferences get preferences => _preferences.value;
  bool get isInitialized => _isInitialized.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeNotifications();
  }

  /// Initialize Firebase Messaging and Local Notifications
  Future<void> _initializeNotifications() async {
    try {
      // Request notification permissions
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        Get.snackbar(
          AppStrings.success,
          AppStrings.notificationPermissionGranted,
          snackPosition: SnackPosition.TOP,
        );
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      await _getFCMToken();

      // Set up message handlers
      _setupMessageHandlers();

      // Register device token with backend
      await _registerDeviceToken();

      _isInitialized.value = true;
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.notificationInitError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Get FCM token from Firebase
  Future<void> _getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      _fcmToken.value = token;
      
      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken.value = newToken;
        _registerDeviceToken(); // Re-register with new token
      });
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  /// Setup Firebase message handlers
  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Handle messages when app is terminated
    FirebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleTerminatedMessage(message);
      }
    });
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Show local notification when app is in foreground
    await _showLocalNotification(message);
    
    // Add to notifications list
    _addNotificationToList(message);
  }

  /// Handle background messages
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // Navigate to appropriate screen based on message data
    _navigateFromNotification(message);
  }

  /// Handle terminated messages
  Future<void> _handleTerminatedMessage(RemoteMessage message) async {
    // Navigate to appropriate screen when app is opened from terminated state
    _navigateFromNotification(message);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'nerutalk_channel',
      'NeruTalk Notifications',
      channelDescription: 'Notifications from NeruTalk app',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      message.notification?.title ?? 'NeruTalk',
      message.notification?.body ?? 'New message',
      details,
      payload: message.data['payload'],
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      // Navigate based on payload
      _navigateFromPayload(response.payload!);
    }
  }

  /// Navigate from notification
  void _navigateFromNotification(RemoteMessage message) {
    String? type = message.data['type'];
    String? targetId = message.data['target_id'];

    switch (type) {
      case 'chat':
        if (targetId != null) {
          Get.toNamed('/chat-detail', parameters: {'chatId': targetId});
        }
        break;
      case 'call':
        if (targetId != null) {
          Get.toNamed('/video-call', parameters: {'callId': targetId});
        }
        break;
      case 'system':
        Get.toNamed('/notifications');
        break;
      default:
        Get.toNamed('/home');
    }
  }

  /// Navigate from payload
  void _navigateFromPayload(String payload) {
    // Parse payload and navigate accordingly
    // This is a simplified implementation
    Get.toNamed('/notifications');
  }

  /// Add notification to list
  void _addNotificationToList(RemoteMessage message) {
    final notification = PushNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'NeruTalk',
      body: message.notification?.body ?? 'New message',
      data: message.data,
      type: message.data['type'] ?? 'system',
      recipientUserIds: [],
      createdAt: DateTime.now(),
    );

    _notifications.insert(0, notification);
  }

  /// Register device token with backend
  Future<void> _registerDeviceToken() async {
    if (_fcmToken.value == null) return;

    try {
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      
      String deviceType = Platform.isAndroid ? 'android' : 'ios';
      String deviceId = '';
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      }

      final tokenData = {
        'token': _fcmToken.value,
        'device_type': deviceType,
        'device_id': deviceId,
        'app_version': packageInfo.version,
      };

      final response = await _networkService.post(
        '${AppConfig.apiBaseUrl}/push-notifications/device-tokens',
        tokenData,
      );

      if (response.isSuccess) {
        final deviceToken = DeviceToken.fromJson(response.data);
        _deviceTokens.add(deviceToken);
      }
    } catch (e) {
      print('Error registering device token: $e');
    }
  }

  /// Get user's device tokens
  Future<void> getUserDeviceTokens() async {
    try {
      final response = await _networkService.get(
        '${AppConfig.apiBaseUrl}/push-notifications/device-tokens',
      );

      if (response.isSuccess) {
        final tokens = (response.data as List)
            .map((json) => DeviceToken.fromJson(json))
            .toList();
        _deviceTokens.assignAll(tokens);
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.loadDeviceTokensError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Update device token
  Future<void> updateDeviceToken(String tokenId, Map<String, dynamic> updates) async {
    try {
      final response = await _networkService.put(
        '${AppConfig.apiBaseUrl}/push-notifications/device-tokens/$tokenId',
        updates,
      );

      if (response.isSuccess) {
        final updatedToken = DeviceToken.fromJson(response.data);
        final index = _deviceTokens.indexWhere((token) => token.id == tokenId);
        if (index != -1) {
          _deviceTokens[index] = updatedToken;
        }
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.updateDeviceTokenError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Remove device token
  Future<void> removeDeviceToken(String tokenId) async {
    try {
      final response = await _networkService.delete(
        '${AppConfig.apiBaseUrl}/push-notifications/device-tokens/$tokenId',
      );

      if (response.isSuccess) {
        _deviceTokens.removeWhere((token) => token.id == tokenId);
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.removeDeviceTokenError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Send notification to specific users
  Future<void> sendNotification({
    required String title,
    required String body,
    required List<String> recipientUserIds,
    String type = 'system',
    String priority = 'normal',
    Map<String, dynamic>? data,
    String? imageUrl,
    String? clickAction,
  }) async {
    try {
      final notificationData = {
        'title': title,
        'body': body,
        'recipient_user_ids': recipientUserIds,
        'type': type,
        'priority': priority,
        'data': data,
        'image_url': imageUrl,
        'click_action': clickAction,
      };

      final response = await _networkService.post(
        '${AppConfig.apiBaseUrl}/push-notifications/send',
        notificationData,
      );

      if (response.isSuccess) {
        Get.snackbar(
          AppStrings.success,
          AppStrings.notificationSentSuccess,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.sendNotificationError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Broadcast notification to all users
  Future<void> broadcastNotification({
    required String title,
    required String body,
    String type = 'broadcast',
    String priority = 'normal',
    Map<String, dynamic>? data,
    String? imageUrl,
    String? clickAction,
  }) async {
    try {
      final notificationData = {
        'title': title,
        'body': body,
        'type': type,
        'priority': priority,
        'data': data,
        'image_url': imageUrl,
        'click_action': clickAction,
      };

      final response = await _networkService.post(
        '${AppConfig.apiBaseUrl}/push-notifications/broadcast',
        notificationData,
      );

      if (response.isSuccess) {
        Get.snackbar(
          AppStrings.success,
          AppStrings.broadcastSentSuccess,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.broadcastNotificationError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Get notification statistics
  Future<Map<String, dynamic>?> getNotificationStats({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }
      if (type != null) {
        queryParams['type'] = type;
      }

      final response = await _networkService.get(
        '${AppConfig.apiBaseUrl}/push-notifications/stats',
        queryParams: queryParams,
      );

      if (response.isSuccess) {
        return response.data;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.loadNotificationStatsError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
    return null;
  }

  /// Get notification preferences
  Future<void> getNotificationPreferences() async {
    try {
      final response = await _networkService.get(
        '${AppConfig.apiBaseUrl}/profile/notification-preferences',
      );

      if (response.isSuccess) {
        _preferences.value = NotificationPreferences.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.loadNotificationPreferencesError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Update notification preferences
  Future<void> updateNotificationPreferences(NotificationPreferences preferences) async {
    try {
      final response = await _networkService.put(
        '${AppConfig.apiBaseUrl}/profile/notification-preferences',
        preferences.toJson(),
      );

      if (response.isSuccess) {
        _preferences.value = NotificationPreferences.fromJson(response.data);
        Get.snackbar(
          AppStrings.success,
          AppStrings.notificationPreferencesUpdated,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.updateNotificationPreferencesError}: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Clear all notifications
  void clearNotifications() {
    _notifications.clear();
  }

  /// Clear notification by id
  void clearNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
  }

  /// Get unread notification count
  int get unreadCount => _notifications.length;
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages here
  print('Handling a background message: ${message.messageId}');
}
