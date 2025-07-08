import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../../core/services/settings_service.dart';

/// Settings page binding for dependency injection
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Register SettingsService if not already registered
    if (!Get.isRegistered<SettingsService>()) {
      Get.lazyPut<SettingsService>(() => SettingsService());
    }
    
    // Register SettingsController
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
