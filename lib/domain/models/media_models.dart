/// File and media related data models
/// These models represent the structure of file sharing data in the application

enum FileType {
  image,
  video,
  document,
  audio,
  sticker,
  gif,
  other,
}

enum FileStatus {
  uploading,
  uploaded,
  failed,
  downloading,
  downloaded,
}

/// Represents a file attachment
class FileAttachment {
  final String id;
  final String name;
  final String? originalName;
  final FileType type;
  final String url;
  final String? thumbnailUrl;
  final int size; // in bytes
  final String? mimeType;
  final FileStatus status;
  final double? uploadProgress;
  final double? downloadProgress;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const FileAttachment({
    required this.id,
    required this.name,
    this.originalName,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    required this.size,
    this.mimeType,
    this.status = FileStatus.uploaded,
    this.uploadProgress,
    this.downloadProgress,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a copy of this file with modified fields
  FileAttachment copyWith({
    String? id,
    String? name,
    String? originalName,
    FileType? type,
    String? url,
    String? thumbnailUrl,
    int? size,
    String? mimeType,
    FileStatus? status,
    double? uploadProgress,
    double? downloadProgress,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FileAttachment(
      id: id ?? this.id,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      type: type ?? this.type,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      status: status ?? this.status,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'originalName': originalName,
      'type': type.name,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'size': size,
      'mimeType': mimeType,
      'status': status.name,
      'uploadProgress': uploadProgress,
      'downloadProgress': downloadProgress,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory FileAttachment.fromJson(Map<String, dynamic> json) {
    return FileAttachment(
      id: json['id'] as String,
      name: json['name'] as String,
      originalName: json['originalName'] as String?,
      type: FileType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FileType.other,
      ),
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      size: json['size'] as int,
      mimeType: json['mimeType'] as String?,
      status: FileStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FileStatus.uploaded,
      ),
      uploadProgress: json['uploadProgress'] as double?,
      downloadProgress: json['downloadProgress'] as double?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Get formatted file size
  String get formattedSize {
    if (size < 1024) {
      return '${size}B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)}KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  /// Get file extension
  String get extension {
    return name.split('.').last.toLowerCase();
  }

  /// Check if file is an image
  bool get isImage {
    return type == FileType.image;
  }

  /// Check if file is a video
  bool get isVideo {
    return type == FileType.video;
  }

  /// Check if file is a document
  bool get isDocument {
    return type == FileType.document;
  }

  /// Check if file is downloading/uploading
  bool get isProcessing {
    return status == FileStatus.uploading || status == FileStatus.downloading;
  }

  @override
  String toString() {
    return 'FileAttachment(id: $id, name: $name, type: $type, size: $formattedSize)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileAttachment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a sticker pack
class StickerPack {
  final String id;
  final String name;
  final String description;
  final String? thumbnailUrl;
  final List<Sticker> stickers;
  final bool isPremium;
  final bool isInstalled;
  final DateTime createdAt;

  const StickerPack({
    required this.id,
    required this.name,
    required this.description,
    this.thumbnailUrl,
    required this.stickers,
    this.isPremium = false,
    this.isInstalled = false,
    required this.createdAt,
  });

  /// Create a copy of this sticker pack with modified fields
  StickerPack copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnailUrl,
    List<Sticker>? stickers,
    bool? isPremium,
    bool? isInstalled,
    DateTime? createdAt,
  }) {
    return StickerPack(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      stickers: stickers ?? this.stickers,
      isPremium: isPremium ?? this.isPremium,
      isInstalled: isInstalled ?? this.isInstalled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'stickers': stickers.map((s) => s.toJson()).toList(),
      'isPremium': isPremium,
      'isInstalled': isInstalled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory StickerPack.fromJson(Map<String, dynamic> json) {
    return StickerPack(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      stickers: (json['stickers'] as List)
          .map((s) => Sticker.fromJson(s as Map<String, dynamic>))
          .toList(),
      isPremium: json['isPremium'] as bool? ?? false,
      isInstalled: json['isInstalled'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'StickerPack(id: $id, name: $name, stickersCount: ${stickers.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StickerPack && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a single sticker
class Sticker {
  final String id;
  final String packId;
  final String name;
  final String url;
  final String? thumbnailUrl;
  final List<String> tags;
  final DateTime createdAt;

  const Sticker({
    required this.id,
    required this.packId,
    required this.name,
    required this.url,
    this.thumbnailUrl,
    required this.tags,
    required this.createdAt,
  });

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packId': packId,
      'name': name,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory Sticker.fromJson(Map<String, dynamic> json) {
    return Sticker(
      id: json['id'] as String,
      packId: json['packId'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      tags: List<String>.from(json['tags'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Sticker(id: $id, name: $name, packId: $packId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Sticker && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a GIF from external service
class GifItem {
  final String id;
  final String title;
  final String url;
  final String? thumbnailUrl;
  final String? previewUrl;
  final int width;
  final int height;
  final String source; // giphy, tenor, etc.
  final List<String> tags;

  const GifItem({
    required this.id,
    required this.title,
    required this.url,
    this.thumbnailUrl,
    this.previewUrl,
    required this.width,
    required this.height,
    required this.source,
    required this.tags,
  });

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'previewUrl': previewUrl,
      'width': width,
      'height': height,
      'source': source,
      'tags': tags,
    };
  }

  /// Create from JSON map
  factory GifItem.fromJson(Map<String, dynamic> json) {
    return GifItem(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      previewUrl: json['previewUrl'] as String?,
      width: json['width'] as int,
      height: json['height'] as int,
      source: json['source'] as String,
      tags: List<String>.from(json['tags'] as List),
    );
  }

  /// Get aspect ratio
  double get aspectRatio {
    if (height == 0) return 1.0;
    return width / height;
  }

  @override
  String toString() {
    return 'GifItem(id: $id, title: $title, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GifItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents media gallery item
class MediaItem {
  final String id;
  final String chatId;
  final FileAttachment file;
  final DateTime createdAt;
  final String? senderId;
  final String? senderName;

  const MediaItem({
    required this.id,
    required this.chatId,
    required this.file,
    required this.createdAt,
    this.senderId,
    this.senderName,
  });

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'file': file.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'senderId': senderId,
      'senderName': senderName,
    };
  }

  /// Create from JSON map
  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      file: FileAttachment.fromJson(json['file'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
    );
  }

  @override
  String toString() {
    return 'MediaItem(id: $id, chatId: $chatId, fileType: ${file.type})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MediaItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
