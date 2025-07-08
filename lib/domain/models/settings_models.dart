import 'package:equatable/equatable.dart';

/// App settings model
class AppSettings extends Equatable {
  final String userId;
  final String language;
  final String theme; // 'light', 'dark', 'system'
  final String fontSize; // 'small', 'medium', 'large'
  final bool enableAnimations;
  final bool enableSounds;
  final bool enableVibration;
  final bool enableNotifications;
  final bool enableAutoDownload;
  final String downloadQuality; // 'low', 'medium', 'high'
  final bool enableLocationServices;
  final bool enableBiometric;
  final String dataUsageMode; // 'unlimited', 'low', 'extreme'
  final DateTime? updatedAt;

  const AppSettings({
    required this.userId,
    this.language = 'en',
    this.theme = 'system',
    this.fontSize = 'medium',
    this.enableAnimations = true,
    this.enableSounds = true,
    this.enableVibration = true,
    this.enableNotifications = true,
    this.enableAutoDownload = true,
    this.downloadQuality = 'medium',
    this.enableLocationServices = false,
    this.enableBiometric = false,
    this.dataUsageMode = 'unlimited',
    this.updatedAt,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      userId: json['user_id'],
      language: json['language'] ?? 'en',
      theme: json['theme'] ?? 'system',
      fontSize: json['font_size'] ?? 'medium',
      enableAnimations: json['enable_animations'] ?? true,
      enableSounds: json['enable_sounds'] ?? true,
      enableVibration: json['enable_vibration'] ?? true,
      enableNotifications: json['enable_notifications'] ?? true,
      enableAutoDownload: json['enable_auto_download'] ?? true,
      downloadQuality: json['download_quality'] ?? 'medium',
      enableLocationServices: json['enable_location_services'] ?? false,
      enableBiometric: json['enable_biometric'] ?? false,
      dataUsageMode: json['data_usage_mode'] ?? 'unlimited',
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'language': language,
      'theme': theme,
      'font_size': fontSize,
      'enable_animations': enableAnimations,
      'enable_sounds': enableSounds,
      'enable_vibration': enableVibration,
      'enable_notifications': enableNotifications,
      'enable_auto_download': enableAutoDownload,
      'download_quality': downloadQuality,
      'enable_location_services': enableLocationServices,
      'enable_biometric': enableBiometric,
      'data_usage_mode': dataUsageMode,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        userId,
        language,
        theme,
        fontSize,
        enableAnimations,
        enableSounds,
        enableVibration,
        enableNotifications,
        enableAutoDownload,
        downloadQuality,
        enableLocationServices,
        enableBiometric,
        dataUsageMode,
        updatedAt,
      ];

  AppSettings copyWith({
    String? userId,
    String? language,
    String? theme,
    String? fontSize,
    bool? enableAnimations,
    bool? enableSounds,
    bool? enableVibration,
    bool? enableNotifications,
    bool? enableAutoDownload,
    String? downloadQuality,
    bool? enableLocationServices,
    bool? enableBiometric,
    String? dataUsageMode,
    DateTime? updatedAt,
  }) {
    return AppSettings(
      userId: userId ?? this.userId,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableSounds: enableSounds ?? this.enableSounds,
      enableVibration: enableVibration ?? this.enableVibration,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableAutoDownload: enableAutoDownload ?? this.enableAutoDownload,
      downloadQuality: downloadQuality ?? this.downloadQuality,
      enableLocationServices: enableLocationServices ?? this.enableLocationServices,
      enableBiometric: enableBiometric ?? this.enableBiometric,
      dataUsageMode: dataUsageMode ?? this.dataUsageMode,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Privacy settings model
class PrivacySettings extends Equatable {
  final String userId;
  final bool showLastSeen;
  final bool showOnlineStatus;
  final bool showProfilePhoto;
  final bool showAbout;
  final bool showPhoneNumber;
  final bool allowGroupInvites;
  final bool allowContactsToAddMe;
  final bool allowStrangersToAddMe;
  final String whoCanSeeMyStory; // 'everyone', 'contacts', 'nobody'
  final String whoCanCallMe; // 'everyone', 'contacts', 'nobody'
  final String whoCanAddMeToGroups; // 'everyone', 'contacts', 'nobody'
  final bool readReceipts;
  final bool typingIndicators;
  final List<String> blockedUsers;
  final DateTime? updatedAt;

  const PrivacySettings({
    required this.userId,
    this.showLastSeen = true,
    this.showOnlineStatus = true,
    this.showProfilePhoto = true,
    this.showAbout = true,
    this.showPhoneNumber = false,
    this.allowGroupInvites = true,
    this.allowContactsToAddMe = true,
    this.allowStrangersToAddMe = false,
    this.whoCanSeeMyStory = 'contacts',
    this.whoCanCallMe = 'contacts',
    this.whoCanAddMeToGroups = 'contacts',
    this.readReceipts = true,
    this.typingIndicators = true,
    this.blockedUsers = const [],
    this.updatedAt,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      userId: json['user_id'],
      showLastSeen: json['show_last_seen'] ?? true,
      showOnlineStatus: json['show_online_status'] ?? true,
      showProfilePhoto: json['show_profile_photo'] ?? true,
      showAbout: json['show_about'] ?? true,
      showPhoneNumber: json['show_phone_number'] ?? false,
      allowGroupInvites: json['allow_group_invites'] ?? true,
      allowContactsToAddMe: json['allow_contacts_to_add_me'] ?? true,
      allowStrangersToAddMe: json['allow_strangers_to_add_me'] ?? false,
      whoCanSeeMyStory: json['who_can_see_my_story'] ?? 'contacts',
      whoCanCallMe: json['who_can_call_me'] ?? 'contacts',
      whoCanAddMeToGroups: json['who_can_add_me_to_groups'] ?? 'contacts',
      readReceipts: json['read_receipts'] ?? true,
      typingIndicators: json['typing_indicators'] ?? true,
      blockedUsers: List<String>.from(json['blocked_users'] ?? []),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'show_last_seen': showLastSeen,
      'show_online_status': showOnlineStatus,
      'show_profile_photo': showProfilePhoto,
      'show_about': showAbout,
      'show_phone_number': showPhoneNumber,
      'allow_group_invites': allowGroupInvites,
      'allow_contacts_to_add_me': allowContactsToAddMe,
      'allow_strangers_to_add_me': allowStrangersToAddMe,
      'who_can_see_my_story': whoCanSeeMyStory,
      'who_can_call_me': whoCanCallMe,
      'who_can_add_me_to_groups': whoCanAddMeToGroups,
      'read_receipts': readReceipts,
      'typing_indicators': typingIndicators,
      'blocked_users': blockedUsers,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        userId,
        showLastSeen,
        showOnlineStatus,
        showProfilePhoto,
        showAbout,
        showPhoneNumber,
        allowGroupInvites,
        allowContactsToAddMe,
        allowStrangersToAddMe,
        whoCanSeeMyStory,
        whoCanCallMe,
        whoCanAddMeToGroups,
        readReceipts,
        typingIndicators,
        blockedUsers,
        updatedAt,
      ];

  PrivacySettings copyWith({
    String? userId,
    bool? showLastSeen,
    bool? showOnlineStatus,
    bool? showProfilePhoto,
    bool? showAbout,
    bool? showPhoneNumber,
    bool? allowGroupInvites,
    bool? allowContactsToAddMe,
    bool? allowStrangersToAddMe,
    String? whoCanSeeMyStory,
    String? whoCanCallMe,
    String? whoCanAddMeToGroups,
    bool? readReceipts,
    bool? typingIndicators,
    List<String>? blockedUsers,
    DateTime? updatedAt,
  }) {
    return PrivacySettings(
      userId: userId ?? this.userId,
      showLastSeen: showLastSeen ?? this.showLastSeen,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      showProfilePhoto: showProfilePhoto ?? this.showProfilePhoto,
      showAbout: showAbout ?? this.showAbout,
      showPhoneNumber: showPhoneNumber ?? this.showPhoneNumber,
      allowGroupInvites: allowGroupInvites ?? this.allowGroupInvites,
      allowContactsToAddMe: allowContactsToAddMe ?? this.allowContactsToAddMe,
      allowStrangersToAddMe: allowStrangersToAddMe ?? this.allowStrangersToAddMe,
      whoCanSeeMyStory: whoCanSeeMyStory ?? this.whoCanSeeMyStory,
      whoCanCallMe: whoCanCallMe ?? this.whoCanCallMe,
      whoCanAddMeToGroups: whoCanAddMeToGroups ?? this.whoCanAddMeToGroups,
      readReceipts: readReceipts ?? this.readReceipts,
      typingIndicators: typingIndicators ?? this.typingIndicators,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Security settings model
class SecuritySettings extends Equatable {
  final String userId;
  final bool twoFactorAuth;
  final bool biometricAuth;
  final bool screenLock;
  final int lockTimeout; // in minutes
  final bool incognitoKeyboard;
  final bool showSecurityNotifications;
  final bool requireAuthForSensitiveActions;
  final List<String> trustedDevices;
  final List<SecurityLog> securityLogs;
  final DateTime? lastPasswordChange;
  final DateTime? updatedAt;

  const SecuritySettings({
    required this.userId,
    this.twoFactorAuth = false,
    this.biometricAuth = false,
    this.screenLock = false,
    this.lockTimeout = 30,
    this.incognitoKeyboard = false,
    this.showSecurityNotifications = true,
    this.requireAuthForSensitiveActions = true,
    this.trustedDevices = const [],
    this.securityLogs = const [],
    this.lastPasswordChange,
    this.updatedAt,
  });

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      userId: json['user_id'],
      twoFactorAuth: json['two_factor_auth'] ?? false,
      biometricAuth: json['biometric_auth'] ?? false,
      screenLock: json['screen_lock'] ?? false,
      lockTimeout: json['lock_timeout'] ?? 30,
      incognitoKeyboard: json['incognito_keyboard'] ?? false,
      showSecurityNotifications: json['show_security_notifications'] ?? true,
      requireAuthForSensitiveActions: json['require_auth_for_sensitive_actions'] ?? true,
      trustedDevices: List<String>.from(json['trusted_devices'] ?? []),
      securityLogs: (json['security_logs'] as List?)
          ?.map((log) => SecurityLog.fromJson(log))
          .toList() ?? [],
      lastPasswordChange: json['last_password_change'] != null 
          ? DateTime.parse(json['last_password_change']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'two_factor_auth': twoFactorAuth,
      'biometric_auth': biometricAuth,
      'screen_lock': screenLock,
      'lock_timeout': lockTimeout,
      'incognito_keyboard': incognitoKeyboard,
      'show_security_notifications': showSecurityNotifications,
      'require_auth_for_sensitive_actions': requireAuthForSensitiveActions,
      'trusted_devices': trustedDevices,
      'security_logs': securityLogs.map((log) => log.toJson()).toList(),
      'last_password_change': lastPasswordChange?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        userId,
        twoFactorAuth,
        biometricAuth,
        screenLock,
        lockTimeout,
        incognitoKeyboard,
        showSecurityNotifications,
        requireAuthForSensitiveActions,
        trustedDevices,
        securityLogs,
        lastPasswordChange,
        updatedAt,
      ];

  SecuritySettings copyWith({
    String? userId,
    bool? twoFactorAuth,
    bool? biometricAuth,
    bool? screenLock,
    int? lockTimeout,
    bool? incognitoKeyboard,
    bool? showSecurityNotifications,
    bool? requireAuthForSensitiveActions,
    List<String>? trustedDevices,
    List<SecurityLog>? securityLogs,
    DateTime? lastPasswordChange,
    DateTime? updatedAt,
  }) {
    return SecuritySettings(
      userId: userId ?? this.userId,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      biometricAuth: biometricAuth ?? this.biometricAuth,
      screenLock: screenLock ?? this.screenLock,
      lockTimeout: lockTimeout ?? this.lockTimeout,
      incognitoKeyboard: incognitoKeyboard ?? this.incognitoKeyboard,
      showSecurityNotifications: showSecurityNotifications ?? this.showSecurityNotifications,
      requireAuthForSensitiveActions: requireAuthForSensitiveActions ?? this.requireAuthForSensitiveActions,
      trustedDevices: trustedDevices ?? this.trustedDevices,
      securityLogs: securityLogs ?? this.securityLogs,
      lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Security log model
class SecurityLog extends Equatable {
  final String id;
  final String userId;
  final String action;
  final String deviceInfo;
  final String? ipAddress;
  final String? location;
  final DateTime timestamp;

  const SecurityLog({
    required this.id,
    required this.userId,
    required this.action,
    required this.deviceInfo,
    this.ipAddress,
    this.location,
    required this.timestamp,
  });

  factory SecurityLog.fromJson(Map<String, dynamic> json) {
    return SecurityLog(
      id: json['id'],
      userId: json['user_id'],
      action: json['action'],
      deviceInfo: json['device_info'],
      ipAddress: json['ip_address'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'action': action,
      'device_info': deviceInfo,
      'ip_address': ipAddress,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        action,
        deviceInfo,
        ipAddress,
        location,
        timestamp,
      ];
}

/// Account settings model
class AccountSettings extends Equatable {
  final String userId;
  final bool isActive;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime? accountCreatedAt;
  final DateTime? lastLoginAt;
  final DateTime? lastActiveAt;
  final String accountType; // 'free', 'premium', 'business'
  final String subscriptionStatus; // 'active', 'expired', 'cancelled'
  final DateTime? subscriptionExpiresAt;
  final bool allowDataCollection;
  final bool allowAnalytics;
  final bool allowMarketing;
  final DateTime? updatedAt;

  const AccountSettings({
    required this.userId,
    this.isActive = true,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.accountCreatedAt,
    this.lastLoginAt,
    this.lastActiveAt,
    this.accountType = 'free',
    this.subscriptionStatus = 'active',
    this.subscriptionExpiresAt,
    this.allowDataCollection = false,
    this.allowAnalytics = false,
    this.allowMarketing = false,
    this.updatedAt,
  });

  factory AccountSettings.fromJson(Map<String, dynamic> json) {
    return AccountSettings(
      userId: json['user_id'],
      isActive: json['is_active'] ?? true,
      emailVerified: json['email_verified'] ?? false,
      phoneVerified: json['phone_verified'] ?? false,
      accountCreatedAt: json['account_created_at'] != null 
          ? DateTime.parse(json['account_created_at']) 
          : null,
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.parse(json['last_login_at']) 
          : null,
      lastActiveAt: json['last_active_at'] != null 
          ? DateTime.parse(json['last_active_at']) 
          : null,
      accountType: json['account_type'] ?? 'free',
      subscriptionStatus: json['subscription_status'] ?? 'active',
      subscriptionExpiresAt: json['subscription_expires_at'] != null 
          ? DateTime.parse(json['subscription_expires_at']) 
          : null,
      allowDataCollection: json['allow_data_collection'] ?? false,
      allowAnalytics: json['allow_analytics'] ?? false,
      allowMarketing: json['allow_marketing'] ?? false,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'is_active': isActive,
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'account_created_at': accountCreatedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
      'account_type': accountType,
      'subscription_status': subscriptionStatus,
      'subscription_expires_at': subscriptionExpiresAt?.toIso8601String(),
      'allow_data_collection': allowDataCollection,
      'allow_analytics': allowAnalytics,
      'allow_marketing': allowMarketing,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        userId,
        isActive,
        emailVerified,
        phoneVerified,
        accountCreatedAt,
        lastLoginAt,
        lastActiveAt,
        accountType,
        subscriptionStatus,
        subscriptionExpiresAt,
        allowDataCollection,
        allowAnalytics,
        allowMarketing,
        updatedAt,
      ];

  AccountSettings copyWith({
    String? userId,
    bool? isActive,
    bool? emailVerified,
    bool? phoneVerified,
    DateTime? accountCreatedAt,
    DateTime? lastLoginAt,
    DateTime? lastActiveAt,
    String? accountType,
    String? subscriptionStatus,
    DateTime? subscriptionExpiresAt,
    bool? allowDataCollection,
    bool? allowAnalytics,
    bool? allowMarketing,
    DateTime? updatedAt,
  }) {
    return AccountSettings(
      userId: userId ?? this.userId,
      isActive: isActive ?? this.isActive,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      accountCreatedAt: accountCreatedAt ?? this.accountCreatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      accountType: accountType ?? this.accountType,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionExpiresAt: subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      allowDataCollection: allowDataCollection ?? this.allowDataCollection,
      allowAnalytics: allowAnalytics ?? this.allowAnalytics,
      allowMarketing: allowMarketing ?? this.allowMarketing,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
