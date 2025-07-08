import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';

/// Binding for NotificationPreferencesPage
/// Uses existing NotificationController if available, creates new if not
class NotificationPreferencesBinding extends Bindings {
  @override
  void dependencies() {
    // Use existing controller if available, otherwise create new one
    if (!Get.isRegistered<NotificationController>()) {
      Get.lazyPut<NotificationController>(
        () => NotificationController(),
      );
    }
  }
}
