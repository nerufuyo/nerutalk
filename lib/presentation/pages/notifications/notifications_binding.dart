import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';

/// Binding for NotificationsPage
/// Initializes the NotificationController dependency
class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
  }
}
