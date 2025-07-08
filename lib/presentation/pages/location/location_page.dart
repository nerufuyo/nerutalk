import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nerutalk/core/constants/app_colors.dart';
import 'package:nerutalk/core/constants/app_strings.dart';
import 'package:nerutalk/presentation/controllers/location_controller.dart';
import 'package:nerutalk/presentation/widgets/common/loading_indicator.dart';

class LocationPage extends GetView<LocationController> {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.location.tr),
        actions: [
          Obx(() => Switch(
            value: controller.isLocationSharingEnabled.value,
            onChanged: controller.toggleLocationSharing,
            activeColor: AppColors.primary,
          )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentLocationCard(),
            const SizedBox(height: 24),
            _buildNearbyUsersSection(),
            const SizedBox(height: 24),
            _buildGeofencesSection(),
            const SizedBox(height: 24),
            _buildLocationHistorySection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.shareCurrentLocation,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.share_location, color: Colors.white),
      ),
    );
  }

  Widget _buildCurrentLocationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.my_location,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.currentLocation.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Obx(() => controller.isLoadingLocation.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        onPressed: controller.refreshLocation,
                        icon: const Icon(Icons.refresh),
                      )),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              final location = controller.currentLocation.value;
              if (location == null) {
                return Text(
                  AppStrings.locationNotAvailable.tr,
                  style: TextStyle(color: AppColors.textSecondary),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (location.address != null) ...[
                    Text(
                      location.address!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    location.coordinates,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppStrings.accuracy.tr}: ${location.accuracy?.toStringAsFixed(0) ?? '?'}m',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyUsersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppStrings.nearbyUsers.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: controller.findNearbyUsers,
              child: Text(AppStrings.refresh.tr),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isLoadingNearby.value) {
            return const LoadingIndicator();
          }

          if (controller.nearbyUsers.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    AppStrings.noNearbyUsers.tr,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            );
          }

          return Column(
            children: controller.nearbyUsers.map((user) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    backgroundImage: user.avatarUrl != null
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                    child: user.avatarUrl == null
                        ? Text(
                            user.name?[0]?.toUpperCase() ?? 'U',
                            style: const TextStyle(color: Colors.white),
                          )
                        : null,
                  ),
                  title: Text(user.name ?? AppStrings.unknownUser.tr),
                  subtitle: Text(user.formattedDistance),
                  trailing: user.isFriend
                      ? Icon(Icons.person, color: AppColors.primary)
                      : IconButton(
                          onPressed: () => controller.sendFriendRequest(user.userId),
                          icon: const Icon(Icons.person_add),
                        ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildGeofencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppStrings.geofences.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: controller.createGeofence,
              icon: const Icon(Icons.add_location),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.geofences.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    AppStrings.noGeofences.tr,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            );
          }

          return Column(
            children: controller.geofences.map((geofence) {
              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: geofence.isActive ? AppColors.primary : AppColors.textSecondary,
                  ),
                  title: Text(geofence.name),
                  subtitle: Text('${AppStrings.radius.tr}: ${geofence.formattedRadius}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => controller.handleGeofenceAction(geofence, value),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(AppStrings.edit.tr),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          AppStrings.delete.tr,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildLocationHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppStrings.locationHistory.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: controller.viewFullHistory,
              child: Text(AppStrings.viewAll.tr),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.recentLocations.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    AppStrings.noLocationHistory.tr,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            );
          }

          return Column(
            children: controller.recentLocations.take(3).map((location) {
              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.history,
                    color: AppColors.textSecondary,
                  ),
                  title: Text(location.address ?? location.coordinates),
                  subtitle: Text(_formatTime(location.timestamp)),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ${AppStrings.daysAgo.tr}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${AppStrings.hoursAgo.tr}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${AppStrings.minutesAgo.tr}';
    } else {
      return AppStrings.now.tr;
    }
  }
}
