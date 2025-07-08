/// User model representing a user in the system
class User {
  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final bool isActive;
  final bool isVerified;
  final bool isOnline;
  final DateTime? lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserSettings? settings;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.isActive = true,
    this.isVerified = false,
    this.isOnline = false,
    this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
    this.settings,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      isActive: json['is_active'] ?? true,
      isVerified: json['is_verified'] ?? false,
      isOnline: json['is_online'] ?? false,
      lastSeen: json['last_seen'] != null ? DateTime.parse(json['last_seen']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      settings: json['settings'] != null ? UserSettings.fromJson(json['settings']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'is_active': isActive,
      'is_verified': isVerified,
      'is_online': isOnline,
      'last_seen': lastSeen?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'settings': settings?.toJson(),
    };
  }

  User copyWith({
    String? username,
    String? email,
    String? displayName,
    String? avatarUrl,
    String? bio,
    bool? isActive,
    bool? isVerified,
    bool? isOnline,
    DateTime? lastSeen,
    UserSettings? settings,
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      settings: settings ?? this.settings,
    );
  }

  /// Get display name or fallback to username
  String get name => displayName?.isNotEmpty == true ? displayName! : username;

  /// Get avatar initials
  String get initials {
    final name = this.name;
    if (name.isEmpty) return 'U';
    
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0].toUpperCase()}${words[1][0].toUpperCase()}';
    } else {
      return name[0].toUpperCase();
    }
  }

  /// Get online status text
  String getOnlineStatusText() {
    if (isOnline) return 'Online';
    if (lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(lastSeen!);
      
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return 'Last seen ${lastSeen!.day}/${lastSeen!.month}/${lastSeen!.year}';
      }
    }
    return 'Offline';
  }
}

/// User settings model
class UserSettings {
  final String userId;
  final LanguageSettings language;
  final ThemeSettings theme;
  final NotificationSettings notifications;
  final PrivacySettings privacy;
  final ChatSettings chat;

  const UserSettings({
    required this.userId,
    required this.language,
    required this.theme,
    required this.notifications,
    required this.privacy,
    required this.chat,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'],
      language: LanguageSettings.fromJson(json['language'] ?? {}),
      theme: ThemeSettings.fromJson(json['theme'] ?? {}),
      notifications: NotificationSettings.fromJson(json['notifications'] ?? {}),
      privacy: PrivacySettings.fromJson(json['privacy'] ?? {}),
      chat: ChatSettings.fromJson(json['chat'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'language': language.toJson(),
      'theme': theme.toJson(),
      'notifications': notifications.toJson(),
      'privacy': privacy.toJson(),
      'chat': chat.toJson(),
    };
  }

  UserSettings copyWith({
    LanguageSettings? language,
    ThemeSettings? theme,
    NotificationSettings? notifications,
    PrivacySettings? privacy,
    ChatSettings? chat,
  }) {
    return UserSettings(
      userId: userId,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      chat: chat ?? this.chat,
    );
  }
}

/// Language settings
class LanguageSettings {
  final String code;
  final bool autoDetect;

  const LanguageSettings({
    required this.code,
    this.autoDetect = true,
  });

  factory LanguageSettings.fromJson(Map<String, dynamic> json) {
    return LanguageSettings(
      code: json['code'] ?? 'en',
      autoDetect: json['auto_detect'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'auto_detect': autoDetect,
    };
  }
}

/// Theme settings
class ThemeSettings {
  final ThemeMode mode;
  final bool followSystem;

  const ThemeSettings({
    required this.mode,
    this.followSystem = true,
  });

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      mode: ThemeMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => ThemeMode.system,
      ),
      followSystem: json['follow_system'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.name,
      'follow_system': followSystem,
    };
  }
}

/// Notification settings
class NotificationSettings {
  final bool enabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool showPreview;
  final bool messageNotifications;
  final bool callNotifications;
  final bool groupNotifications;

  const NotificationSettings({
    this.enabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.showPreview = true,
    this.messageNotifications = true,
    this.callNotifications = true,
    this.groupNotifications = true,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      enabled: json['enabled'] ?? true,
      soundEnabled: json['sound_enabled'] ?? true,
      vibrationEnabled: json['vibration_enabled'] ?? true,
      showPreview: json['show_preview'] ?? true,
      messageNotifications: json['message_notifications'] ?? true,
      callNotifications: json['call_notifications'] ?? true,
      groupNotifications: json['group_notifications'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'sound_enabled': soundEnabled,
      'vibration_enabled': vibrationEnabled,
      'show_preview': showPreview,
      'message_notifications': messageNotifications,
      'call_notifications': callNotifications,
      'group_notifications': groupNotifications,
    };
  }
}

/// Privacy settings
class PrivacySettings {
  final bool shareLocation;
  final bool showOnlineStatus;
  final bool showLastSeen;
  final bool allowContactsOnly;
  final bool readReceipts;

  const PrivacySettings({
    this.shareLocation = false,
    this.showOnlineStatus = true,
    this.showLastSeen = true,
    this.allowContactsOnly = false,
    this.readReceipts = true,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      shareLocation: json['share_location'] ?? false,
      showOnlineStatus: json['show_online_status'] ?? true,
      showLastSeen: json['show_last_seen'] ?? true,
      allowContactsOnly: json['allow_contacts_only'] ?? false,
      readReceipts: json['read_receipts'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'share_location': shareLocation,
      'show_online_status': showOnlineStatus,
      'show_last_seen': showLastSeen,
      'allow_contacts_only': allowContactsOnly,
      'read_receipts': readReceipts,
    };
  }
}

/// Chat settings
class ChatSettings {
  final bool enterToSend;
  final bool showTypingIndicator;
  final String fontSize;
  final bool mediaAutoDownload;

  const ChatSettings({
    this.enterToSend = false,
    this.showTypingIndicator = true,
    this.fontSize = 'medium',
    this.mediaAutoDownload = true,
  });

  factory ChatSettings.fromJson(Map<String, dynamic> json) {
    return ChatSettings(
      enterToSend: json['enter_to_send'] ?? false,
      showTypingIndicator: json['show_typing_indicator'] ?? true,
      fontSize: json['font_size'] ?? 'medium',
      mediaAutoDownload: json['media_auto_download'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enter_to_send': enterToSend,
      'show_typing_indicator': showTypingIndicator,
      'font_size': fontSize,
      'media_auto_download': mediaAutoDownload,
    };
  }
}

/// Contact model
class Contact {
  final String id;
  final String userId;
  final String contactUserId;
  final String? nickname;
  final bool isBlocked;
  final bool isFavorite;
  final DateTime createdAt;
  final User? contactUser;

  const Contact({
    required this.id,
    required this.userId,
    required this.contactUserId,
    this.nickname,
    this.isBlocked = false,
    this.isFavorite = false,
    required this.createdAt,
    this.contactUser,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'].toString(),
      userId: json['user_id'],
      contactUserId: json['contact_user_id'],
      nickname: json['nickname'],
      isBlocked: json['is_blocked'] ?? false,
      isFavorite: json['is_favorite'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      contactUser: json['contact_user'] != null ? User.fromJson(json['contact_user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'contact_user_id': contactUserId,
      'nickname': nickname,
      'is_blocked': isBlocked,
      'is_favorite': isFavorite,
      'created_at': createdAt.toIso8601String(),
      'contact_user': contactUser?.toJson(),
    };
  }

  /// Get display name for contact
  String getDisplayName() {
    if (nickname != null && nickname!.isNotEmpty) {
      return nickname!;
    }
    return contactUser?.name ?? 'Unknown Contact';
  }
}

/// Theme mode enum
enum ThemeMode { light, dark, system }
