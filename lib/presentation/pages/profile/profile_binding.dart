import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

/// Binding for ProfilePage
/// Initializes the ProfileController dependency
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
