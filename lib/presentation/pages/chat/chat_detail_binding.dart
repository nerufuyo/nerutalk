import 'package:get/get.dart';
import 'package:nerutalk/presentation/controllers/chat_detail_controller.dart';

class ChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatDetailController>(() => ChatDetailController());
  }
}
