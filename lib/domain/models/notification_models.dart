import 'package:equatable/equatable.dart';

/// Notification device token model
class DeviceToken extends Equatable {
  final String id;
  final String token;
  final String deviceType; // 'android', 'ios', 'web'
  final String deviceId;
  final String appVersion;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  const DeviceToken({
    required this.id,
    required this.token,
    required this.deviceType,
    required this.deviceId,
    required this.appVersion,
    this.isActive = true,
    required this.createdAt,
    this.lastUsedAt,
  });

  factory DeviceToken.fromJson(Map<String, dynamic> json) {
    return DeviceToken(
      id: json['id'],
      token: json['token'],
      deviceType: json['device_type'],
      deviceId: json['device_id'],
      appVersion: json['app_version'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      lastUsedAt: json['last_used_at'] != null 
          ? DateTime.parse(json['last_used_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'device_type': deviceType,
      'device_id': deviceId,
      'app_version': appVersion,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_used_at': lastUsedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        token,
        deviceType,
        deviceId,
        appVersion,
        isActive,
        createdAt,
        lastUsedAt,
      ];

  DeviceToken copyWith({
    String? id,
    String? token,
    String? deviceType,
    String? deviceId,
    String? appVersion,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) {
    return DeviceToken(
      id: id ?? this.id,
      token: token ?? this.token,
      deviceType: deviceType ?? this.deviceType,
      deviceId: deviceId ?? this.deviceId,
      appVersion: appVersion ?? this.appVersion,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }
}

/// Push notification model
class PushNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? clickAction;
  final String type; // 'chat', 'call', 'system', 'broadcast'
  final String priority; // 'low', 'normal', 'high'
  final List<String> recipientUserIds;
  final String? senderId;
  final NotificationStatus status;
  final DateTime createdAt;
  final DateTime? sentAt;
  final DateTime? scheduledAt;
  final NotificationStats? stats;

  const PushNotification({
    required this.id,
    required this.title,
    required this.body,
    this.data,
    this.imageUrl,
    this.clickAction,
    required this.type,
    this.priority = 'normal',
    required this.recipientUserIds,
    this.senderId,
    this.status = NotificationStatus.pending,
    required this.createdAt,
    this.sentAt,
    this.scheduledAt,
    this.stats,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      data: json['data'],
      imageUrl: json['image_url'],
      clickAction: json['click_action'],
      type: json['type'],
      priority: json['priority'] ?? 'normal',
      recipientUserIds: List<String>.from(json['recipient_user_ids'] ?? []),
      senderId: json['sender_id'],
      status: NotificationStatus.values.byName(json['status']),
      createdAt: DateTime.parse(json['created_at']),
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at']) : null,
      scheduledAt: json['scheduled_at'] != null 
          ? DateTime.parse(json['scheduled_at']) 
          : null,
      stats: json['stats'] != null 
          ? NotificationStats.fromJson(json['stats']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'data': data,
      'image_url': imageUrl,
      'click_action': clickAction,
      'type': type,
      'priority': priority,
      'recipient_user_ids': recipientUserIds,
      'sender_id': senderId,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'sent_at': sentAt?.toIso8601String(),
      'scheduled_at': scheduledAt?.toIso8601String(),
      'stats': stats?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        data,
        imageUrl,
        clickAction,
        type,
        priority,
        recipientUserIds,
        senderId,
        status,
        createdAt,
        sentAt,
        scheduledAt,
        stats,
      ];

  PushNotification copyWith({
    String? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? clickAction,
    String? type,
    String? priority,
    List<String>? recipientUserIds,
    String? senderId,
    NotificationStatus? status,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? scheduledAt,
    NotificationStats? stats,
  }) {
    return PushNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      clickAction: clickAction ?? this.clickAction,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      recipientUserIds: recipientUserIds ?? this.recipientUserIds,
      senderId: senderId ?? this.senderId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      stats: stats ?? this.stats,
    );
  }
}

/// Notification status enum
enum NotificationStatus {
  pending,
  sending,
  sent,
  delivered,
  failed,
  cancelled
}

/// Notification statistics model
class NotificationStats extends Equatable {
  final int totalRecipients;
  final int delivered;
  final int failed;
  final int clicked;
  final double deliveryRate;
  final double clickRate;
  final Map<String, int> platformBreakdown;

  const NotificationStats({
    required this.totalRecipients,
    required this.delivered,
    required this.failed,
    required this.clicked,
    required this.deliveryRate,
    required this.clickRate,
    required this.platformBreakdown,
  });

  factory NotificationStats.fromJson(Map<String, dynamic> json) {
    return NotificationStats(
      totalRecipients: json['total_recipients'],
      delivered: json['delivered'],
      failed: json['failed'],
      clicked: json['clicked'],
      deliveryRate: json['delivery_rate'].toDouble(),
      clickRate: json['click_rate'].toDouble(),
      platformBreakdown: Map<String, int>.from(json['platform_breakdown']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_recipients': totalRecipients,
      'delivered': delivered,
      'failed': failed,
      'clicked': clicked,
      'delivery_rate': deliveryRate,
      'click_rate': clickRate,
      'platform_breakdown': platformBreakdown,
    };
  }

  @override
  List<Object?> get props => [
        totalRecipients,
        delivered,
        failed,
        clicked,
        deliveryRate,
        clickRate,
        platformBreakdown,
      ];
}

/// Notification template model
class NotificationTemplate extends Equatable {
  final String id;
  final String name;
  final String type;
  final String titleTemplate;
  final String bodyTemplate;
  final Map<String, dynamic>? defaultData;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const NotificationTemplate({
    required this.id,
    required this.name,
    required this.type,
    required this.titleTemplate,
    required this.bodyTemplate,
    this.defaultData,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory NotificationTemplate.fromJson(Map<String, dynamic> json) {
    return NotificationTemplate(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      titleTemplate: json['title_template'],
      bodyTemplate: json['body_template'],
      defaultData: json['default_data'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'title_template': titleTemplate,
      'body_template': bodyTemplate,
      'default_data': defaultData,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        titleTemplate,
        bodyTemplate,
        defaultData,
        isActive,
        createdAt,
        updatedAt,
      ];
}

/// Notification preferences model
class NotificationPreferences extends Equatable {
  final String userId;
  final bool enablePush;
  final bool enableChat;
  final bool enableCalls;
  final bool enableSystem;
  final bool enableBroadcast;
  final bool enableSound;
  final bool enableVibration;
  final String quietHoursStart;
  final String quietHoursEnd;
  final bool enableQuietHours;
  final DateTime? updatedAt;

  const NotificationPreferences({
    required this.userId,
    this.enablePush = true,
    this.enableChat = true,
    this.enableCalls = true,
    this.enableSystem = true,
    this.enableBroadcast = false,
    this.enableSound = true,
    this.enableVibration = true,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '07:00',
    this.enableQuietHours = false,
    this.updatedAt,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      userId: json['user_id'],
      enablePush: json['enable_push'] ?? true,
      enableChat: json['enable_chat'] ?? true,
      enableCalls: json['enable_calls'] ?? true,
      enableSystem: json['enable_system'] ?? true,
      enableBroadcast: json['enable_broadcast'] ?? false,
      enableSound: json['enable_sound'] ?? true,
      enableVibration: json['enable_vibration'] ?? true,
      quietHoursStart: json['quiet_hours_start'] ?? '22:00',
      quietHoursEnd: json['quiet_hours_end'] ?? '07:00',
      enableQuietHours: json['enable_quiet_hours'] ?? false,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'enable_push': enablePush,
      'enable_chat': enableChat,
      'enable_calls': enableCalls,
      'enable_system': enableSystem,
      'enable_broadcast': enableBroadcast,
      'enable_sound': enableSound,
      'enable_vibration': enableVibration,
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
      'enable_quiet_hours': enableQuietHours,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        userId,
        enablePush,
        enableChat,
        enableCalls,
        enableSystem,
        enableBroadcast,
        enableSound,
        enableVibration,
        quietHoursStart,
        quietHoursEnd,
        enableQuietHours,
        updatedAt,
      ];

  NotificationPreferences copyWith({
    String? userId,
    bool? enablePush,
    bool? enableChat,
    bool? enableCalls,
    bool? enableSystem,
    bool? enableBroadcast,
    bool? enableSound,
    bool? enableVibration,
    String? quietHoursStart,
    String? quietHoursEnd,
    bool? enableQuietHours,
    DateTime? updatedAt,
  }) {
    return NotificationPreferences(
      userId: userId ?? this.userId,
      enablePush: enablePush ?? this.enablePush,
      enableChat: enableChat ?? this.enableChat,
      enableCalls: enableCalls ?? this.enableCalls,
      enableSystem: enableSystem ?? this.enableSystem,
      enableBroadcast: enableBroadcast ?? this.enableBroadcast,
      enableSound: enableSound ?? this.enableSound,
      enableVibration: enableVibration ?? this.enableVibration,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      enableQuietHours: enableQuietHours ?? this.enableQuietHours,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
