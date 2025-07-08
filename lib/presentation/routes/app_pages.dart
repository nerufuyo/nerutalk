import 'package:get/get.dart';
import 'app_routes.dart';
import '../pages/splash/splash_page.dart';
import '../pages/splash/splash_binding.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/onboarding/onboarding_binding.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/login_binding.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/register_binding.dart';
import '../pages/home/home_page.dart';
import '../pages/home/home_binding.dart';

/// Application page routes configuration
/// Defines all GetX pages with their bindings and transitions
abstract class AppPages {
  /// List of all application pages
  static final List<GetPage> pages = [
    // Splash Page
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Onboarding Page
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Authentication Pages
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Main App Pages
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
