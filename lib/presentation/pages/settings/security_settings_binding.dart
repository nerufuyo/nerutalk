import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';

/// Security settings page binding
class SecuritySettingsBinding extends Bindings {
  @override
  void dependencies() {
    // SettingsController should already be registered from SettingsBinding
    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(() => SettingsController());
    }
  }
}
