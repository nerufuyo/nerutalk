import 'package:get/get.dart';
import 'splash_controller.dart';

/// Splash page binding for dependency injection
/// Initializes the splash controller when the page is loaded
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
      fenix: true,
    );
  }
}
