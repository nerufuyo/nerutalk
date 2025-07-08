import 'package:flutter/material.dart';
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
      middlewares: [AuthMiddleware()],
    ),

    // Chat Pages
    // GetPage(
    //   name: AppRoutes.chats,
    //   page: () => const ChatsPage(),
    //   binding: ChatsBinding(),
    //   transition: Transition.cupertino,
    //   transitionDuration: const Duration(milliseconds: 300),
    //   middlewares: [AuthMiddleware()],
    // ),

    // Profile Pages
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => const ProfilePage(),
    //   binding: ProfileBinding(),
    //   transition: Transition.cupertino,
    //   transitionDuration: const Duration(milliseconds: 300),
    //   middlewares: [AuthMiddleware()],
    // ),

    // Settings Pages
    // GetPage(
    //   name: AppRoutes.settings,
    //   page: () => const SettingsPage(),
    //   binding: SettingsBinding(),
    //   transition: Transition.cupertino,
    //   transitionDuration: const Duration(milliseconds: 300),
    //   middlewares: [AuthMiddleware()],
    // ),

    // Error Pages
    // GetPage(
    //   name: AppRoutes.error,
    //   page: () => const ErrorPage(),
    //   binding: ErrorBinding(),
    //   transition: Transition.fade,
    //   transitionDuration: const Duration(milliseconds: 300),
    // ),

    // GetPage(
    //   name: AppRoutes.notFound,
    //   page: () => const ErrorPage(),
    //   binding: ErrorBinding(),
    //   transition: Transition.fade,
    //   transitionDuration: const Duration(milliseconds: 300),
    // ),
  ];

  /// Unknown route handler
  static GetPage get unknownRoute {
    return GetPage(
      name: AppRoutes.notFound,
      page: () => const Scaffold(body: Center(child: Text('Page Not Found'))),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Get page by route name
  static GetPage? getPageByRoute(String routeName) {
    try {
      return pages.firstWhere((page) => page.name == routeName);
    } catch (e) {
      return null;
    }
  }

  /// Check if route exists
  static bool routeExists(String routeName) {
    return pages.any((page) => page.name == routeName);
  }

  /// Get all page names
  static List<String> getAllPageNames() {
    return pages.map((page) => page.name).toList();
  }

  /// Get pages by category
  static List<GetPage> getPagesByCategory(String category) {
    return pages.where((page) {
      final routeCategory = AppRoutes.getRouteCategory(page.name);
      return routeCategory == category;
    }).toList();
  }
}

/// Authentication middleware to protect routes
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // TODO: Implement actual authentication check
    // For now, allow all routes
    return null;

    // Example implementation:
    // final authService = Get.find<AuthService>();
    // if (!authService.isAuthenticated()) {
    //   return const RouteSettings(name: AppRoutes.login);
    // }
    // return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    // Log page access for analytics
    if (page != null) {
      print('📱 Navigating to: ${page.name}');
    }
    return page;
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    // Initialize common bindings if needed
    return bindings;
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    // Add common widgets or logic before page build
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    // Wrap page with common widgets if needed
    return page;
  }

  @override
  void onPageDispose() {
    // Cleanup when page is disposed
    print('📱 Page disposed');
  }
}

/// Network middleware to handle offline scenarios
class NetworkMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    // TODO: Check network status and redirect to offline page if needed
    return null;
  }
}

/// Feature flag middleware to control access to features
class FeatureFlagMiddleware extends GetMiddleware {
  final String feature;

  FeatureFlagMiddleware(this.feature);

  @override
  int? get priority => 3;

  @override
  RouteSettings? redirect(String? route) {
    // TODO: Check if feature is enabled
    // final config = Get.find<AppConfig>();
    // if (!config.isFeatureEnabled(feature)) {
    //   return const RouteSettings(name: AppRoutes.notFound);
    // }
    return null;
  }
}

/// Development middleware for debug builds
class DevelopmentMiddleware extends GetMiddleware {
  @override
  int? get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    // Only allow access in debug builds
    // if (kReleaseMode && route?.startsWith('/debug') == true) {
    //   return const RouteSettings(name: AppRoutes.notFound);
    // }
    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    // Log detailed navigation info in debug mode
    if (page != null) {
      print('🔧 [DEBUG] Page: ${page.name}');
      print('🔧 [DEBUG] Bindings: ${page.binding}');
      print('🔧 [DEBUG] Transition: ${page.transition}');
    }
    return page;
  }
}
