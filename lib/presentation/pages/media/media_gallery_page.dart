import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nerutalk/core/constants/app_colors.dart';
import 'package:nerutalk/core/constants/app_strings.dart';
import 'package:nerutalk/presentation/controllers/media_gallery_controller.dart';
import 'package:nerutalk/presentation/widgets/common/loading_indicator.dart';

class MediaGalleryPage extends GetView<MediaGalleryController> {
  const MediaGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.mediaGallery.tr),
        actions: [
          IconButton(
            onPressed: controller.selectFiles,
            icon: const Icon(Icons.add_photo_alternate),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingIndicator();
              }

              if (controller.filteredItems.isEmpty) {
                return _buildEmptyState();
              }

              return _buildMediaGrid();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.filterTypes.length,
        itemBuilder: (context, index) {
          final type = controller.filterTypes[index];
          final isSelected = controller.selectedFilter.value == type;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_getFilterLabel(type)),
              selected: isSelected,
              onSelected: (_) => controller.setFilter(type),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      )),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noMediaFiles.tr,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.shareFirstMedia.tr,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: controller.filteredItems.length,
      itemBuilder: (context, index) {
        final item = controller.filteredItems[index];
        return _buildMediaItem(item);
      },
    );
  }

  Widget _buildMediaItem(dynamic item) {
    return GestureDetector(
      onTap: () => controller.openMediaViewer(item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.surface,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Media preview
              _buildMediaPreview(item),
              
              // Media type indicator
              if (item.file.type.name == 'video') ...[
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
              
              // File size indicator
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.file.formattedSize,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview(dynamic item) {
    if (item.file.thumbnailUrl != null) {
      return Image.network(
        item.file.thumbnailUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFileIcon(item.file.type);
        },
      );
    } else if (item.file.isImage) {
      return Image.network(
        item.file.url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFileIcon(item.file.type);
        },
      );
    } else {
      return _buildFileIcon(item.file.type);
    }
  }

  Widget _buildFileIcon(dynamic fileType) {
    IconData icon;
    Color color;
    
    switch (fileType.toString()) {
      case 'FileType.video':
        icon = Icons.videocam;
        color = Colors.red;
        break;
      case 'FileType.audio':
        icon = Icons.audiotrack;
        color = Colors.blue;
        break;
      case 'FileType.document':
        icon = Icons.description;
        color = Colors.orange;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = AppColors.textSecondary;
    }
    
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Icon(
          icon,
          size: 40,
          color: color,
        ),
      ),
    );
  }

  String _getFilterLabel(String type) {
    switch (type) {
      case 'all':
        return AppStrings.all.tr;
      case 'image':
        return AppStrings.images.tr;
      case 'video':
        return AppStrings.videos.tr;
      case 'document':
        return AppStrings.documents.tr;
      default:
        return type.toUpperCase();
    }
  }
}
