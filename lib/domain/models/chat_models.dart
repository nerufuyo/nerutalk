/// Chat model representing a conversation
class Chat {
  final String id;
  final String? name;
  final String? description;
  final ChatType type;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatParticipant> participants;
  final Message? lastMessage;
  final int unreadCount;
  final String? avatarUrl;

  const Chat({
    required this.id,
    this.name,
    this.description,
    required this.type,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.participants = const [],
    this.lastMessage,
    this.unreadCount = 0,
    this.avatarUrl,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      type: ChatType.values.firstWhere(
        (e) => e.name == json['chat_type'],
        orElse: () => ChatType.private,
      ),
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((p) => ChatParticipant.fromJson(p))
              .toList() ??
          [],
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'chat_type': type.name,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'avatar_url': avatarUrl,
    };
  }

  Chat copyWith({
    String? name,
    String? description,
    ChatType? type,
    List<ChatParticipant>? participants,
    Message? lastMessage,
    int? unreadCount,
    String? avatarUrl,
  }) {
    return Chat(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  /// Get display name for the chat
  String getDisplayName(String currentUserId) {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }

    if (type == ChatType.private) {
      final otherParticipant = participants.firstWhere(
        (p) => p.userId != currentUserId,
        orElse: () => ChatParticipant(
          id: '',
          chatId: id,
          userId: currentUserId,
          displayName: 'Unknown User',
          role: ParticipantRole.member,
          joinedAt: DateTime.now(),
        ),
      );
      return otherParticipant.displayName ?? 'Unknown User';
    }

    return 'Group Chat';
  }

  /// Get avatar URL for the chat
  String? getAvatarUrl(String currentUserId) {
    if (avatarUrl != null) {
      return avatarUrl;
    }

    if (type == ChatType.private) {
      final otherParticipant = participants.firstWhere(
        (p) => p.userId != currentUserId,
        orElse: () => ChatParticipant(
          id: '',
          chatId: id,
          userId: currentUserId,
          role: ParticipantRole.member,
          joinedAt: DateTime.now(),
        ),
      );
      return otherParticipant.avatarUrl;
    }

    return null;
  }
}

/// Chat participant model
class ChatParticipant {
  final String id;
  final String chatId;
  final String userId;
  final String? displayName;
  final String? avatarUrl;
  final ParticipantRole role;
  final DateTime joinedAt;
  final DateTime? leftAt;
  final bool isOnline;
  final DateTime? lastSeen;

  const ChatParticipant({
    required this.id,
    required this.chatId,
    required this.userId,
    this.displayName,
    this.avatarUrl,
    required this.role,
    required this.joinedAt,
    this.leftAt,
    this.isOnline = false,
    this.lastSeen,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'].toString(),
      chatId: json['chat_id'].toString(),
      userId: json['user_id'],
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
      role: ParticipantRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => ParticipantRole.member,
      ),
      joinedAt: DateTime.parse(json['joined_at']),
      leftAt: json['left_at'] != null ? DateTime.parse(json['left_at']) : null,
      isOnline: json['is_online'] ?? false,
      lastSeen: json['last_seen'] != null ? DateTime.parse(json['last_seen']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'user_id': userId,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'role': role.name,
      'joined_at': joinedAt.toIso8601String(),
      'left_at': leftAt?.toIso8601String(),
      'is_online': isOnline,
      'last_seen': lastSeen?.toIso8601String(),
    };
  }
}

/// Message model
class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String content;
  final MessageType type;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? replyToId;
  final Message? replyToMessage;
  final bool isEdited;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MessageStatus status;
  final List<MessageReaction> reactions;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.content,
    required this.type,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.replyToId,
    this.replyToMessage,
    this.isEdited = false,
    required this.createdAt,
    required this.updatedAt,
    this.status = MessageStatus.sent,
    this.reactions = const [],
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(),
      chatId: json['chat_id'].toString(),
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      senderAvatar: json['sender_avatar'],
      content: json['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == json['message_type'],
        orElse: () => MessageType.text,
      ),
      fileUrl: json['file_url'],
      fileName: json['file_name'],
      fileSize: json['file_size'],
      replyToId: json['reply_to_id']?.toString(),
      replyToMessage: json['reply_to_message'] != null
          ? Message.fromJson(json['reply_to_message'])
          : null,
      isEdited: json['is_edited'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((r) => MessageReaction.fromJson(r))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'content': content,
      'message_type': type.name,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'reply_to_id': replyToId,
      'reply_to_message': replyToMessage?.toJson(),
      'is_edited': isEdited,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status.name,
      'reactions': reactions.map((r) => r.toJson()).toList(),
    };
  }

  /// Check if message is from current user
  bool isFromCurrentUser(String currentUserId) {
    return senderId == currentUserId;
  }

  /// Get formatted time
  String getFormattedTime() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    } else if (difference.inHours > 0) {
      return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else {
      return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// Message reaction model
class MessageReaction {
  final String id;
  final String messageId;
  final String userId;
  final String emoji;
  final DateTime createdAt;

  const MessageReaction({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.emoji,
    required this.createdAt,
  });

  factory MessageReaction.fromJson(Map<String, dynamic> json) {
    return MessageReaction(
      id: json['id'].toString(),
      messageId: json['message_id'].toString(),
      userId: json['user_id'],
      emoji: json['emoji'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message_id': messageId,
      'user_id': userId,
      'emoji': emoji,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Enums
enum ChatType { private, group }

enum ParticipantRole { admin, member }

enum MessageType { text, image, video, audio, file, sticker, gif, location, contact }

enum MessageStatus { sending, sent, delivered, read, failed }
