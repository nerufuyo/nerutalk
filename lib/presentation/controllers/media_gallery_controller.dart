import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nerutalk/domain/models/media_models.dart';

class MediaGalleryController extends GetxController {
  final RxList<MediaItem> mediaItems = <MediaItem>[].obs;
  final RxList<MediaItem> filteredItems = <MediaItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'all'.obs;
  
  final List<String> filterTypes = ['all', 'image', 'video', 'document'];

  @override
  void onInit() {
    super.onInit();
    loadMediaItems();
  }

  Future<void> loadMediaItems() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for now
      mediaItems.value = [
        MediaItem(
          id: '1',
          chatId: 'chat_1',
          file: FileAttachment(
            id: 'file_1',
            name: 'photo_1.jpg',
            type: FileType.image,
            url: 'https://picsum.photos/200/200?random=1',
            thumbnailUrl: 'https://picsum.photos/100/100?random=1',
            size: 1024 * 500, // 500KB
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          senderId: 'user1',
          senderName: 'John Doe',
        ),
        MediaItem(
          id: '2',
          chatId: 'chat_1',
          file: FileAttachment(
            id: 'file_2',
            name: 'video_1.mp4',
            type: FileType.video,
            url: 'https://example.com/video1.mp4',
            thumbnailUrl: 'https://picsum.photos/100/100?random=2',
            size: 1024 * 1024 * 5, // 5MB
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          senderId: 'user2',
          senderName: 'Alice Smith',
        ),
        MediaItem(
          id: '3',
          chatId: 'chat_2',
          file: FileAttachment(
            id: 'file_3',
            name: 'document.pdf',
            type: FileType.document,
            url: 'https://example.com/document.pdf',
            size: 1024 * 1024 * 2, // 2MB
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          senderId: 'user3',
          senderName: 'Bob Wilson',
        ),
        MediaItem(
          id: '4',
          chatId: 'chat_1',
          file: FileAttachment(
            id: 'file_4',
            name: 'photo_2.jpg',
            type: FileType.image,
            url: 'https://picsum.photos/200/200?random=3',
            thumbnailUrl: 'https://picsum.photos/100/100?random=3',
            size: 1024 * 800, // 800KB
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          senderId: 'user4',
          senderName: 'Sarah Johnson',
        ),
      ];
      
      _applyFilter();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load media items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedFilter.value == 'all') {
      filteredItems.value = mediaItems;
    } else {
      filteredItems.value = mediaItems.where((item) {
        return item.file.type.name == selectedFilter.value;
      }).toList();
    }
  }

  void selectFiles() {
    // TODO: Implement file picker
    Get.snackbar(
      'File Upload',
      'File picker coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openMediaViewer(MediaItem item) {
    // TODO: Navigate to media viewer page
    Get.snackbar(
      'Media Viewer',
      'Opening ${item.file.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> refreshMedia() async {
    await loadMediaItems();
  }

  void deleteMediaItem(String itemId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Media'),
        content: const Text('Are you sure you want to delete this media file?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              mediaItems.removeWhere((item) => item.id == itemId);
              _applyFilter();
              Get.back();
              Get.snackbar(
                'Success',
                'Media file deleted',
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
}
