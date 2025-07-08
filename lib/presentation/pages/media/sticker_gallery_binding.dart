import 'package:get/get.dart';
import 'package:nerutalk/presentation/controllers/sticker_gallery_controller.dart';

class StickerGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StickerGalleryController>(() => StickerGalleryController());
  }
}
