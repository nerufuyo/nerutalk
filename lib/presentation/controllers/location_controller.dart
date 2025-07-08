import 'package:get/get.dart';
import 'package:nerutalk/domain/models/location_models.dart';

class LocationController extends GetxController {
  final Rxn<UserLocation> currentLocation = Rxn<UserLocation>();
  final RxList<NearbyUser> nearbyUsers = <NearbyUser>[].obs;
  final RxList<GeofenceArea> geofences = <GeofenceArea>[].obs;
  final RxList<UserLocation> recentLocations = <UserLocation>[].obs;
  final RxBool isLocationSharingEnabled = false.obs;
  final RxBool isLoadingLocation = false.obs;
  final RxBool isLoadingNearby = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await refreshLocation();
    await loadGeofences();
    await loadLocationHistory();
  }

  Future<void> refreshLocation() async {
    try {
      isLoadingLocation.value = true;
      
      // TODO: Get actual location using geolocator
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock current location
      currentLocation.value = UserLocation(
        id: 'current_location',
        userId: 'current_user',
        latitude: -6.2088,  // Jakarta coordinates
        longitude: 106.8456,
        accuracy: 10.0,
        address: 'Jakarta, Indonesia',
        timestamp: DateTime.now(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void toggleLocationSharing(bool enabled) {
    isLocationSharingEnabled.value = enabled;
    
    if (enabled) {
      _startLocationSharing();
    } else {
      _stopLocationSharing();
    }
  }

  void _startLocationSharing() {
    // TODO: Start real-time location updates
    Get.snackbar(
      'Location Sharing',
      'Location sharing enabled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _stopLocationSharing() {
    // TODO: Stop real-time location updates
    Get.snackbar(
      'Location Sharing',
      'Location sharing disabled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> findNearbyUsers() async {
    try {
      isLoadingNearby.value = true;
      
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock nearby users
      nearbyUsers.value = [
        NearbyUser(
          userId: 'user1',
          name: 'John Doe',
          location: UserLocation(
            id: 'loc1',
            userId: 'user1',
            latitude: -6.2088,
            longitude: 106.8450,
            timestamp: DateTime.now(),
          ),
          distanceMeters: 150,
          isFriend: true,
          lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        NearbyUser(
          userId: 'user2',
          name: 'Alice Smith',
          location: UserLocation(
            id: 'loc2',
            userId: 'user2',
            latitude: -6.2090,
            longitude: 106.8460,
            timestamp: DateTime.now(),
          ),
          distanceMeters: 250,
          isFriend: false,
          lastSeen: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to find nearby users: $e');
    } finally {
      isLoadingNearby.value = false;
    }
  }

  Future<void> loadGeofences() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock geofences
      geofences.value = [
        GeofenceArea(
          id: 'geofence1',
          userId: 'current_user',
          name: 'Home',
          centerLatitude: -6.2088,
          centerLongitude: 106.8456,
          radiusMeters: 100,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        GeofenceArea(
          id: 'geofence2',
          userId: 'current_user',
          name: 'Office',
          centerLatitude: -6.2100,
          centerLongitude: 106.8400,
          radiusMeters: 200,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load geofences: $e');
    }
  }

  Future<void> loadLocationHistory() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock location history
      recentLocations.value = [
        UserLocation(
          id: 'hist1',
          userId: 'current_user',
          latitude: -6.2088,
          longitude: 106.8456,
          address: 'Home, Jakarta',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        UserLocation(
          id: 'hist2',
          userId: 'current_user',
          latitude: -6.2100,
          longitude: 106.8400,
          address: 'Office, Jakarta',
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        ),
        UserLocation(
          id: 'hist3',
          userId: 'current_user',
          latitude: -6.2200,
          longitude: 106.8300,
          address: 'Mall, Jakarta',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load location history: $e');
    }
  }

  void shareCurrentLocation() {
    // TODO: Implement location sharing dialog
    Get.snackbar(
      'Share Location',
      'Location sharing feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void sendFriendRequest(String userId) {
    // TODO: Send friend request
    Get.snackbar(
      'Friend Request',
      'Friend request sent to user $userId',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void createGeofence() {
    // TODO: Navigate to create geofence page
    Get.snackbar(
      'Create Geofence',
      'Create geofence feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void handleGeofenceAction(GeofenceArea geofence, String action) {
    switch (action) {
      case 'edit':
        // TODO: Navigate to edit geofence page
        Get.snackbar(
          'Edit Geofence',
          'Edit ${geofence.name}',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 'delete':
        _deleteGeofence(geofence);
        break;
    }
  }

  void _deleteGeofence(GeofenceArea geofence) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Geofence'),
        content: Text('Are you sure you want to delete "${geofence.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              geofences.removeWhere((g) => g.id == geofence.id);
              Get.back();
              Get.snackbar(
                'Success',
                'Geofence deleted',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void viewFullHistory() {
    // TODO: Navigate to full location history page
    Get.snackbar(
      'Location History',
      'Full location history coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
