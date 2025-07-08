import 'package:equatable/equatable.dart';

/// Extended user profile model with comprehensive user information
class UserProfile extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? avatarUrl;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? location;
  final String? website;
  final String? status; // 'online', 'offline', 'away', 'busy'
  final String? statusMessage;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSeenAt;
  final ProfilePrivacySettings? privacySettings;
  final Map<String, dynamic>? metadata;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.firstName,
    this.lastName,
    this.bio,
    this.avatarUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.location,
    this.website,
    this.status = 'offline',
    this.statusMessage,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.lastSeenAt,
    this.privacySettings,
    this.metadata,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      displayName: json['display_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth']) 
          : null,
      location: json['location'],
      website: json['website'],
      status: json['status'] ?? 'offline',
      statusMessage: json['status_message'],
      isEmailVerified: json['is_email_verified'] ?? false,
      isPhoneVerified: json['is_phone_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lastSeenAt: json['last_seen_at'] != null 
          ? DateTime.parse(json['last_seen_at']) 
          : null,
      privacySettings: json['privacy_settings'] != null
          ? ProfilePrivacySettings.fromJson(json['privacy_settings'])
          : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'display_name': displayName,
      'first_name': firstName,
      'last_name': lastName,
      'bio': bio,
      'avatar_url': avatarUrl,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'location': location,
      'website': website,
      'status': status,
      'status_message': statusMessage,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_seen_at': lastSeenAt?.toIso8601String(),
      'privacy_settings': privacySettings?.toJson(),
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        displayName,
        firstName,
        lastName,
        bio,
        avatarUrl,
        phoneNumber,
        dateOfBirth,
        location,
        website,
        status,
        statusMessage,
        isEmailVerified,
        isPhoneVerified,
        isActive,
        createdAt,
        updatedAt,
        lastSeenAt,
        privacySettings,
        metadata,
      ];

  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? bio,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? location,
    String? website,
    String? status,
    String? statusMessage,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSeenAt,
    ProfilePrivacySettings? privacySettings,
    Map<String, dynamic>? metadata,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      location: location ?? this.location,
      website: website ?? this.website,
      status: status ?? this.status,
      statusMessage: statusMessage ?? this.statusMessage,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      privacySettings: privacySettings ?? this.privacySettings,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get full name from first and last name
  String? get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName;
    } else if (lastName != null) {
      return lastName;
    }
    return null;
  }

  /// Get display name or fallback to username
  String get displayNameOrUsername => displayName ?? username;

  /// Get display name, full name, or username in priority order
  String get bestDisplayName => displayName ?? fullName ?? username;

  /// Check if profile is complete
  bool get isProfileComplete {
    return displayName != null && 
           bio != null && 
           avatarUrl != null;
  }

  /// Get profile completion percentage
  int get profileCompletionPercentage {
    int totalFields = 6; // displayName, bio, avatar, phone, location, dateOfBirth
    int completedFields = 0;

    if (displayName != null && displayName!.isNotEmpty) completedFields++;
    if (bio != null && bio!.isNotEmpty) completedFields++;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) completedFields++;
    if (phoneNumber != null && phoneNumber!.isNotEmpty) completedFields++;
    if (location != null && location!.isNotEmpty) completedFields++;
    if (dateOfBirth != null) completedFields++;

    return ((completedFields / totalFields) * 100).round();
  }
}

/// Profile privacy settings model
class ProfilePrivacySettings extends Equatable {
  final String userId;
  final bool showEmail;
  final bool showPhoneNumber;
  final bool showLastSeen;
  final bool showOnlineStatus;
  final bool allowSearchByEmail;
  final bool allowSearchByPhone;
  final bool showLocation;
  final bool allowLocationSharing;
  final String profileVisibility; // 'public', 'contacts', 'private'
  final bool allowFriendRequests;
  final bool allowGroupInvites;
  final bool allowCallsFromContacts;
  final bool allowCallsFromAnyone;
  final DateTime? updatedAt;

  const ProfilePrivacySettings({
    required this.userId,
    this.showEmail = false,
    this.showPhoneNumber = false,
    this.showLastSeen = true,
    this.showOnlineStatus = true,
    this.allowSearchByEmail = true,
    this.allowSearchByPhone = true,
    this.showLocation = false,
    this.allowLocationSharing = false,
    this.profileVisibility = 'contacts',
    this.allowFriendRequests = true,
    this.allowGroupInvites = true,
    this.allowCallsFromContacts = true,
    this.allowCallsFromAnyone = false,
    this.updatedAt,
  });

  factory ProfilePrivacySettings.fromJson(Map<String, dynamic> json) {
    return ProfilePrivacySettings(
      userId: json['user_id'],
      showEmail: json['show_email'] ?? false,
      showPhoneNumber: json['show_phone_number'] ?? false,
      showLastSeen: json['show_last_seen'] ?? true,
      showOnlineStatus: json['show_online_status'] ?? true,
      allowSearchByEmail: json['allow_search_by_email'] ?? true,
      allowSearchByPhone: json['allow_search_by_phone'] ?? true,
      showLocation: json['show_location'] ?? false,
      allowLocationSharing: json['allow_location_sharing'] ?? false,
      profileVisibility: json['profile_visibility'] ?? 'contacts',
      allowFriendRequests: json['allow_friend_requests'] ?? true,
      allowGroupInvites: json['allow_group_invites'] ?? true,
      allowCallsFromContacts: json['allow_calls_from_contacts'] ?? true,
      allowCallsFromAnyone: json['allow_calls_from_anyone'] ?? false,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'show_email': showEmail,
      'show_phone_number': showPhoneNumber,
      'show_last_seen': showLastSeen,
      'show_online_status': showOnlineStatus,
      'allow_search_by_email': allowSearchByEmail,
      'allow_search_by_phone': allowSearchByPhone,
      'show_location': showLocation,
      'allow_location_sharing': allowLocationSharing,
      'profile_visibility': profileVisibility,
      'allow_friend_requests': allowFriendRequests,
      'allow_group_invites': allowGroupInvites,
      'allow_calls_from_contacts': allowCallsFromContacts,
      'allow_calls_from_anyone': allowCallsFromAnyone,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        userId,
        showEmail,
        showPhoneNumber,
        showLastSeen,
        showOnlineStatus,
        allowSearchByEmail,
        allowSearchByPhone,
        showLocation,
        allowLocationSharing,
        profileVisibility,
        allowFriendRequests,
        allowGroupInvites,
        allowCallsFromContacts,
        allowCallsFromAnyone,
        updatedAt,
      ];

  ProfilePrivacySettings copyWith({
    String? userId,
    bool? showEmail,
    bool? showPhoneNumber,
    bool? showLastSeen,
    bool? showOnlineStatus,
    bool? allowSearchByEmail,
    bool? allowSearchByPhone,
    bool? showLocation,
    bool? allowLocationSharing,
    String? profileVisibility,
    bool? allowFriendRequests,
    bool? allowGroupInvites,
    bool? allowCallsFromContacts,
    bool? allowCallsFromAnyone,
    DateTime? updatedAt,
  }) {
    return ProfilePrivacySettings(
      userId: userId ?? this.userId,
      showEmail: showEmail ?? this.showEmail,
      showPhoneNumber: showPhoneNumber ?? this.showPhoneNumber,
      showLastSeen: showLastSeen ?? this.showLastSeen,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      allowSearchByEmail: allowSearchByEmail ?? this.allowSearchByEmail,
      allowSearchByPhone: allowSearchByPhone ?? this.allowSearchByPhone,
      showLocation: showLocation ?? this.showLocation,
      allowLocationSharing: allowLocationSharing ?? this.allowLocationSharing,
      profileVisibility: profileVisibility ?? this.profileVisibility,
      allowFriendRequests: allowFriendRequests ?? this.allowFriendRequests,
      allowGroupInvites: allowGroupInvites ?? this.allowGroupInvites,
      allowCallsFromContacts: allowCallsFromContacts ?? this.allowCallsFromContacts,
      allowCallsFromAnyone: allowCallsFromAnyone ?? this.allowCallsFromAnyone,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Avatar upload model
class AvatarUpload extends Equatable {
  final String id;
  final String userId;
  final String originalUrl;
  final String? thumbnailUrl;
  final String fileName;
  final int fileSize;
  final String mimeType;
  final int? width;
  final int? height;
  final UploadStatus status;
  final DateTime createdAt;
  final DateTime? processedAt;

  const AvatarUpload({
    required this.id,
    required this.userId,
    required this.originalUrl,
    this.thumbnailUrl,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    this.width,
    this.height,
    this.status = UploadStatus.pending,
    required this.createdAt,
    this.processedAt,
  });

  factory AvatarUpload.fromJson(Map<String, dynamic> json) {
    return AvatarUpload(
      id: json['id'],
      userId: json['user_id'],
      originalUrl: json['original_url'],
      thumbnailUrl: json['thumbnail_url'],
      fileName: json['file_name'],
      fileSize: json['file_size'],
      mimeType: json['mime_type'],
      width: json['width'],
      height: json['height'],
      status: UploadStatus.values.byName(json['status']),
      createdAt: DateTime.parse(json['created_at']),
      processedAt: json['processed_at'] != null 
          ? DateTime.parse(json['processed_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'original_url': originalUrl,
      'thumbnail_url': thumbnailUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'mime_type': mimeType,
      'width': width,
      'height': height,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        originalUrl,
        thumbnailUrl,
        fileName,
        fileSize,
        mimeType,
        width,
        height,
        status,
        createdAt,
        processedAt,
      ];

  AvatarUpload copyWith({
    String? id,
    String? userId,
    String? originalUrl,
    String? thumbnailUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
    int? width,
    int? height,
    UploadStatus? status,
    DateTime? createdAt,
    DateTime? processedAt,
  }) {
    return AvatarUpload(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      originalUrl: originalUrl ?? this.originalUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      width: width ?? this.width,
      height: height ?? this.height,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }
}

/// Upload status enum
enum UploadStatus {
  pending,
  uploading,
  processing,
  completed,
  failed
}

/// Profile activity model
class ProfileActivity extends Equatable {
  final String id;
  final String userId;
  final String action; // 'profile_updated', 'avatar_changed', 'status_changed'
  final String description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const ProfileActivity({
    required this.id,
    required this.userId,
    required this.action,
    required this.description,
    this.metadata,
    required this.createdAt,
  });

  factory ProfileActivity.fromJson(Map<String, dynamic> json) {
    return ProfileActivity(
      id: json['id'],
      userId: json['user_id'],
      action: json['action'],
      description: json['description'],
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'action': action,
      'description': description,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        action,
        description,
        metadata,
        createdAt,
      ];
}
