import 'package:get/get.dart';
import 'package:nerutalk/domain/models/media_models.dart';

class StickerGalleryController extends GetxController {
  final RxList<StickerPack> stickerPacks = <StickerPack>[].obs;
  final Rxn<StickerPack> selectedPack = Rxn<StickerPack>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStickerPacks();
  }

  Future<void> loadStickerPacks() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for now
      stickerPacks.value = [
        StickerPack(
          id: 'pack_1',
          name: 'Emotions',
          description: 'Express your emotions',
          thumbnailUrl: 'https://picsum.photos/100/100?random=10',
          isInstalled: true,
          stickers: [
            Sticker(
              id: 'sticker_1',
              packId: 'pack_1',
              name: 'Happy',
              url: 'https://picsum.photos/100/100?random=11',
              tags: ['happy', 'smile'],
              createdAt: DateTime.now(),
            ),
            Sticker(
              id: 'sticker_2',
              packId: 'pack_1',
              name: 'Sad',
              url: 'https://picsum.photos/100/100?random=12',
              tags: ['sad', 'cry'],
              createdAt: DateTime.now(),
            ),
            Sticker(
              id: 'sticker_3',
              packId: 'pack_1',
              name: 'Love',
              url: 'https://picsum.photos/100/100?random=13',
              tags: ['love', 'heart'],
              createdAt: DateTime.now(),
            ),
            Sticker(
              id: 'sticker_4',
              packId: 'pack_1',
              name: 'Angry',
              url: 'https://picsum.photos/100/100?random=14',
              tags: ['angry', 'mad'],
              createdAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now(),
        ),
        StickerPack(
          id: 'pack_2',
          name: 'Animals',
          description: 'Cute animal stickers',
          thumbnailUrl: 'https://picsum.photos/100/100?random=20',
          isInstalled: true,
          stickers: [
            Sticker(
              id: 'sticker_5',
              packId: 'pack_2',
              name: 'Cat',
              url: 'https://picsum.photos/100/100?random=21',
              tags: ['cat', 'cute'],
              createdAt: DateTime.now(),
            ),
            Sticker(
              id: 'sticker_6',
              packId: 'pack_2',
              name: 'Dog',
              url: 'https://picsum.photos/100/100?random=22',
              tags: ['dog', 'puppy'],
              createdAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now(),
        ),
        StickerPack(
          id: 'pack_3',
          name: 'Premium Pack',
          description: 'Premium stickers collection',
          thumbnailUrl: 'https://picsum.photos/100/100?random=30',
          isPremium: true,
          isInstalled: false,
          stickers: [],
          createdAt: DateTime.now(),
        ),
      ];
      
      // Select first installed pack by default
      final firstInstalledPack = stickerPacks.firstWhere(
        (pack) => pack.isInstalled,
        orElse: () => stickerPacks.first,
      );
      selectedPack.value = firstInstalledPack;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load sticker packs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectPack(StickerPack pack) {
    if (!pack.isInstalled) {
      _showInstallDialog(pack);
      return;
    }
    
    selectedPack.value = pack;
  }

  void _showInstallDialog(StickerPack pack) {
    Get.dialog(
      AlertDialog(
        title: Text('Install ${pack.name}'),
        content: Text(pack.description),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _installPack(pack);
            },
            child: Text(
              pack.isPremium ? 'Buy & Install' : 'Install',
              style: TextStyle(
                color: pack.isPremium ? Colors.orange : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _installPack(StickerPack pack) {
    // TODO: Implement actual installation logic
    
    final updatedPack = pack.copyWith(isInstalled: true);
    final index = stickerPacks.indexWhere((p) => p.id == pack.id);
    if (index != -1) {
      stickerPacks[index] = updatedPack;
      selectedPack.value = updatedPack;
    }
    
    Get.snackbar(
      'Success',
      '${pack.name} installed successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void sendSticker(Sticker sticker) {
    // TODO: Send sticker in chat
    Get.back(); // Close sticker gallery
    Get.snackbar(
      'Sticker Sent',
      'Sent ${sticker.name} sticker',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openStickerStore() {
    // TODO: Navigate to sticker store
    Get.snackbar(
      'Sticker Store',
      'Sticker store coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> refreshPacks() async {
    await loadStickerPacks();
  }
}
