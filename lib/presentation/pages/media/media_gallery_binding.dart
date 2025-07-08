import 'package:get/get.dart';
import 'package:nerutalk/presentation/controllers/media_gallery_controller.dart';

class MediaGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MediaGalleryController>(() => MediaGalleryController());
  }
}
