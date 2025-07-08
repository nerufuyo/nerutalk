/// Video call related data models
/// These models represent the structure of video call data in the application

enum CallType {
  video,
  audio,
}

enum CallStatus {
  initiated,
  ringing,
  ongoing,
  ended,
  declined,
  missed,
}

/// Represents a video call session
class VideoCall {
  final String id;
  final String channelName;
  final CallType type;
  final CallStatus status;
  final String initiatedBy;
  final List<String> participants;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? duration; // in seconds
  final Map<String, dynamic>? agoraConfig;
  final DateTime createdAt;

  const VideoCall({
    required this.id,
    required this.channelName,
    required this.type,
    required this.status,
    required this.initiatedBy,
    required this.participants,
    this.startedAt,
    this.endedAt,
    this.duration,
    this.agoraConfig,
    required this.createdAt,
  });

  /// Create a copy of this call with modified fields
  VideoCall copyWith({
    String? id,
    String? channelName,
    CallType? type,
    CallStatus? status,
    String? initiatedBy,
    List<String>? participants,
    DateTime? startedAt,
    DateTime? endedAt,
    int? duration,
    Map<String, dynamic>? agoraConfig,
    DateTime? createdAt,
  }) {
    return VideoCall(
      id: id ?? this.id,
      channelName: channelName ?? this.channelName,
      type: type ?? this.type,
      status: status ?? this.status,
      initiatedBy: initiatedBy ?? this.initiatedBy,
      participants: participants ?? this.participants,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
      agoraConfig: agoraConfig ?? this.agoraConfig,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channelName': channelName,
      'type': type.name,
      'status': status.name,
      'initiatedBy': initiatedBy,
      'participants': participants,
      'startedAt': startedAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'duration': duration,
      'agoraConfig': agoraConfig,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory VideoCall.fromJson(Map<String, dynamic> json) {
    return VideoCall(
      id: json['id'] as String,
      channelName: json['channelName'] as String,
      type: CallType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CallType.video,
      ),
      status: CallStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CallStatus.initiated,
      ),
      initiatedBy: json['initiatedBy'] as String,
      participants: List<String>.from(json['participants'] as List),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      duration: json['duration'] as int?,
      agoraConfig: json['agoraConfig'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Get call duration in a readable format
  String get formattedDuration {
    if (duration == null) return '00:00';
    
    final hours = duration! ~/ 3600;
    final minutes = (duration! % 3600) ~/ 60;
    final seconds = duration! % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Check if call is active
  bool get isActive {
    return status == CallStatus.ongoing || status == CallStatus.ringing;
  }

  /// Check if call is ended
  bool get isEnded {
    return status == CallStatus.ended || 
           status == CallStatus.declined || 
           status == CallStatus.missed;
  }

  @override
  String toString() {
    return 'VideoCall(id: $id, channelName: $channelName, type: $type, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VideoCall && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a call participant
class CallParticipant {
  final String userId;
  final String? name;
  final String? avatarUrl;
  final DateTime? joinedAt;
  final DateTime? leftAt;
  final bool isVideoEnabled;
  final bool isAudioEnabled;
  final bool isScreenSharing;
  final int? agoraUid;

  const CallParticipant({
    required this.userId,
    this.name,
    this.avatarUrl,
    this.joinedAt,
    this.leftAt,
    this.isVideoEnabled = true,
    this.isAudioEnabled = true,
    this.isScreenSharing = false,
    this.agoraUid,
  });

  /// Create a copy of this participant with modified fields
  CallParticipant copyWith({
    String? userId,
    String? name,
    String? avatarUrl,
    DateTime? joinedAt,
    DateTime? leftAt,
    bool? isVideoEnabled,
    bool? isAudioEnabled,
    bool? isScreenSharing,
    int? agoraUid,
  }) {
    return CallParticipant(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
      agoraUid: agoraUid ?? this.agoraUid,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'avatarUrl': avatarUrl,
      'joinedAt': joinedAt?.toIso8601String(),
      'leftAt': leftAt?.toIso8601String(),
      'isVideoEnabled': isVideoEnabled,
      'isAudioEnabled': isAudioEnabled,
      'isScreenSharing': isScreenSharing,
      'agoraUid': agoraUid,
    };
  }

  /// Create from JSON map
  factory CallParticipant.fromJson(Map<String, dynamic> json) {
    return CallParticipant(
      userId: json['userId'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'] as String)
          : null,
      leftAt: json['leftAt'] != null
          ? DateTime.parse(json['leftAt'] as String)
          : null,
      isVideoEnabled: json['isVideoEnabled'] as bool? ?? true,
      isAudioEnabled: json['isAudioEnabled'] as bool? ?? true,
      isScreenSharing: json['isScreenSharing'] as bool? ?? false,
      agoraUid: json['agoraUid'] as int?,
    );
  }

  /// Check if participant is currently in the call
  bool get isInCall {
    return joinedAt != null && leftAt == null;
  }

  @override
  String toString() {
    return 'CallParticipant(userId: $userId, name: $name, isInCall: $isInCall)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CallParticipant && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}

/// Represents call history entry
class CallHistory {
  final String id;
  final String callId;
  final String? otherParticipantId;
  final String? otherParticipantName;
  final String? otherParticipantAvatar;
  final CallType type;
  final CallStatus status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? duration;
  final bool isIncoming;

  const CallHistory({
    required this.id,
    required this.callId,
    this.otherParticipantId,
    this.otherParticipantName,
    this.otherParticipantAvatar,
    required this.type,
    required this.status,
    required this.startedAt,
    this.endedAt,
    this.duration,
    required this.isIncoming,
  });

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'callId': callId,
      'otherParticipantId': otherParticipantId,
      'otherParticipantName': otherParticipantName,
      'otherParticipantAvatar': otherParticipantAvatar,
      'type': type.name,
      'status': status.name,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'duration': duration,
      'isIncoming': isIncoming,
    };
  }

  /// Create from JSON map
  factory CallHistory.fromJson(Map<String, dynamic> json) {
    return CallHistory(
      id: json['id'] as String,
      callId: json['callId'] as String,
      otherParticipantId: json['otherParticipantId'] as String?,
      otherParticipantName: json['otherParticipantName'] as String?,
      otherParticipantAvatar: json['otherParticipantAvatar'] as String?,
      type: CallType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CallType.video,
      ),
      status: CallStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CallStatus.ended,
      ),
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      duration: json['duration'] as int?,
      isIncoming: json['isIncoming'] as bool,
    );
  }

  /// Get formatted duration
  String get formattedDuration {
    if (duration == null) return '00:00';
    
    final hours = duration! ~/ 3600;
    final minutes = (duration! % 3600) ~/ 60;
    final seconds = duration! % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  String toString() {
    return 'CallHistory(id: $id, type: $type, status: $status, isIncoming: $isIncoming)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CallHistory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
