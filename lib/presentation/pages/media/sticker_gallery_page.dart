import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nerutalk/core/constants/app_colors.dart';
import 'package:nerutalk/core/constants/app_strings.dart';
import 'package:nerutalk/presentation/controllers/sticker_gallery_controller.dart';
import 'package:nerutalk/presentation/widgets/common/loading_indicator.dart';

class StickerGalleryPage extends GetView<StickerGalleryController> {
  const StickerGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.stickers.tr),
        actions: [
          IconButton(
            onPressed: controller.openStickerStore,
            icon: const Icon(Icons.store),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPackTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingIndicator();
              }

              if (controller.selectedPack.value == null) {
                return _buildEmptyState();
              }

              return _buildStickerGrid();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPackTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.stickerPacks.length,
        itemBuilder: (context, index) {
          final pack = controller.stickerPacks[index];
          final isSelected = controller.selectedPack.value?.id == pack.id;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => controller.selectPack(pack),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: pack.thumbnailUrl != null
                      ? Image.network(
                          pack.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPackIcon(pack.name);
                          },
                        )
                      : _buildPackIcon(pack.name),
                ),
              ),
            ),
          );
        },
      )),
    );
  }

  Widget _buildPackIcon(String packName) {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Text(
          packName[0].toUpperCase(),
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_emotions_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noStickers.tr,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.downloadStickerPacks.tr,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.openStickerStore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(
              AppStrings.stickerStore.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickerGrid() {
    final selectedPack = controller.selectedPack.value;
    if (selectedPack == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            selectedPack.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: selectedPack.stickers.length,
            itemBuilder: (context, index) {
              final sticker = selectedPack.stickers[index];
              return _buildStickerItem(sticker);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStickerItem(dynamic sticker) {
    return GestureDetector(
      onTap: () => controller.sendSticker(sticker),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.surface,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: sticker.thumbnailUrl != null
              ? Image.network(
                  sticker.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      sticker.url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildStickerPlaceholder();
                      },
                    );
                  },
                )
              : Image.network(
                  sticker.url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildStickerPlaceholder();
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildStickerPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Icon(
          Icons.emoji_emotions,
          color: AppColors.textSecondary,
          size: 32,
        ),
      ),
    );
  }
}
