/// Location tracking and geofencing related data models
/// These models represent location data structures in the application
import 'dart:math' as math;

enum LocationShareType { realTime, temporary, permanent }

enum GeofenceEventType { entry, exit }

/// Represents a user's location
class UserLocation {
  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final double? speed;
  final double? heading;
  final String? address;
  final DateTime timestamp;
  final bool isActive;

  const UserLocation({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    this.heading,
    this.address,
    required this.timestamp,
    this.isActive = true,
  });

  /// Create a copy of this location with modified fields
  UserLocation copyWith({
    String? id,
    String? userId,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    double? heading,
    String? address,
    DateTime? timestamp,
    bool? isActive,
  }) {
    return UserLocation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      address: address ?? this.address,
      timestamp: timestamp ?? this.timestamp,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'heading': heading,
      'address': address,
      'timestamp': timestamp.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Create from JSON map
  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      id: json['id'] as String,
      userId: json['userId'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      accuracy: json['accuracy'] as double?,
      altitude: json['altitude'] as double?,
      speed: json['speed'] as double?,
      heading: json['heading'] as double?,
      address: json['address'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Get coordinates as a readable string
  String get coordinates {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  /// Calculate distance to another location in meters
  double distanceTo(UserLocation other) {
    // Simple distance calculation (not accounting for Earth's curvature)
    const double earthRadiusM = 6371000;
    final double dLat = (other.latitude - latitude) * (math.pi / 180);
    final double dLng = (other.longitude - longitude) * (math.pi / 180);
    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLng / 2) *
            math.sin(dLng / 2) *
            math.cos(latitude * (math.pi / 180)) *
            math.cos(other.latitude * (math.pi / 180));
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusM * c;
  }

  @override
  String toString() {
    return 'UserLocation(id: $id, userId: $userId, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserLocation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents location sharing configuration
class LocationShare {
  final String id;
  final String userId;
  final String? targetUserId; // null for public share
  final String? targetChatId; // null for private share
  final LocationShareType type;
  final DateTime? expiresAt;
  final bool isActive;
  final DateTime createdAt;

  const LocationShare({
    required this.id,
    required this.userId,
    this.targetUserId,
    this.targetChatId,
    required this.type,
    this.expiresAt,
    this.isActive = true,
    required this.createdAt,
  });

  /// Create a copy of this location share with modified fields
  LocationShare copyWith({
    String? id,
    String? userId,
    String? targetUserId,
    String? targetChatId,
    LocationShareType? type,
    DateTime? expiresAt,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return LocationShare(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      targetUserId: targetUserId ?? this.targetUserId,
      targetChatId: targetChatId ?? this.targetChatId,
      type: type ?? this.type,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetUserId': targetUserId,
      'targetChatId': targetChatId,
      'type': type.name,
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory LocationShare.fromJson(Map<String, dynamic> json) {
    return LocationShare(
      id: json['id'] as String,
      userId: json['userId'] as String,
      targetUserId: json['targetUserId'] as String?,
      targetChatId: json['targetChatId'] as String?,
      type: LocationShareType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LocationShareType.temporary,
      ),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Check if location share is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if location share is still valid
  bool get isValid {
    return isActive && !isExpired;
  }

  @override
  String toString() {
    return 'LocationShare(id: $id, type: $type, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationShare && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a geofence area
class GeofenceArea {
  final String id;
  final String userId;
  final String name;
  final double centerLatitude;
  final double centerLongitude;
  final double radiusMeters;
  final bool notifyOnEntry;
  final bool notifyOnExit;
  final bool isActive;
  final DateTime createdAt;

  const GeofenceArea({
    required this.id,
    required this.userId,
    required this.name,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.radiusMeters,
    this.notifyOnEntry = true,
    this.notifyOnExit = true,
    this.isActive = true,
    required this.createdAt,
  });

  /// Create a copy of this geofence with modified fields
  GeofenceArea copyWith({
    String? id,
    String? userId,
    String? name,
    double? centerLatitude,
    double? centerLongitude,
    double? radiusMeters,
    bool? notifyOnEntry,
    bool? notifyOnExit,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return GeofenceArea(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      centerLatitude: centerLatitude ?? this.centerLatitude,
      centerLongitude: centerLongitude ?? this.centerLongitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      notifyOnEntry: notifyOnEntry ?? this.notifyOnEntry,
      notifyOnExit: notifyOnExit ?? this.notifyOnExit,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'radiusMeters': radiusMeters,
      'notifyOnEntry': notifyOnEntry,
      'notifyOnExit': notifyOnExit,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory GeofenceArea.fromJson(Map<String, dynamic> json) {
    return GeofenceArea(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      centerLatitude: json['centerLatitude'] as double,
      centerLongitude: json['centerLongitude'] as double,
      radiusMeters: json['radiusMeters'] as double,
      notifyOnEntry: json['notifyOnEntry'] as bool? ?? true,
      notifyOnExit: json['notifyOnExit'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Check if a location is inside this geofence
  bool containsLocation(UserLocation location) {
    final distance = UserLocation(
      id: 'temp',
      userId: 'temp',
      latitude: centerLatitude,
      longitude: centerLongitude,
      timestamp: DateTime.now(),
    ).distanceTo(location);

    return distance <= radiusMeters;
  }

  /// Get center coordinates as readable string
  String get centerCoordinates {
    return '${centerLatitude.toStringAsFixed(6)}, ${centerLongitude.toStringAsFixed(6)}';
  }

  /// Get formatted radius
  String get formattedRadius {
    if (radiusMeters < 1000) {
      return '${radiusMeters.toInt()}m';
    } else {
      return '${(radiusMeters / 1000).toStringAsFixed(1)}km';
    }
  }

  @override
  String toString() {
    return 'GeofenceArea(id: $id, name: $name, radius: $formattedRadius)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GeofenceArea && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a geofence event
class GeofenceEvent {
  final String id;
  final String userId;
  final String geofenceId;
  final GeofenceEventType eventType;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const GeofenceEvent({
    required this.id,
    required this.userId,
    required this.geofenceId,
    required this.eventType,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'geofenceId': geofenceId,
      'eventType': eventType.name,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory GeofenceEvent.fromJson(Map<String, dynamic> json) {
    return GeofenceEvent(
      id: json['id'] as String,
      userId: json['userId'] as String,
      geofenceId: json['geofenceId'] as String,
      eventType: GeofenceEventType.values.firstWhere(
        (e) => e.name == json['eventType'],
        orElse: () => GeofenceEventType.entry,
      ),
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Get coordinates as readable string
  String get coordinates {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  @override
  String toString() {
    return 'GeofenceEvent(id: $id, type: $eventType, geofenceId: $geofenceId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GeofenceEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a nearby user
class NearbyUser {
  final String userId;
  final String? name;
  final String? avatarUrl;
  final UserLocation location;
  final double distanceMeters;
  final bool isFriend;
  final DateTime lastSeen;

  const NearbyUser({
    required this.userId,
    this.name,
    this.avatarUrl,
    required this.location,
    required this.distanceMeters,
    this.isFriend = false,
    required this.lastSeen,
  });

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'avatarUrl': avatarUrl,
      'location': location.toJson(),
      'distanceMeters': distanceMeters,
      'isFriend': isFriend,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory NearbyUser.fromJson(Map<String, dynamic> json) {
    return NearbyUser(
      userId: json['userId'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      location: UserLocation.fromJson(json['location'] as Map<String, dynamic>),
      distanceMeters: json['distanceMeters'] as double,
      isFriend: json['isFriend'] as bool? ?? false,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
    );
  }

  /// Get formatted distance
  String get formattedDistance {
    if (distanceMeters < 1000) {
      return '${distanceMeters.toInt()}m away';
    } else {
      return '${(distanceMeters / 1000).toStringAsFixed(1)}km away';
    }
  }

  @override
  String toString() {
    return 'NearbyUser(userId: $userId, name: $name, distance: $formattedDistance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NearbyUser && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
