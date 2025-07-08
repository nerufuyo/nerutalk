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
import '../pages/chat/chat_list_page.dart';
import '../pages/chat/chat_list_binding.dart';
import '../pages/chat/chat_detail_page.dart';
import '../pages/chat/chat_detail_binding.dart';
import '../pages/video_call/call_history_page.dart';
import '../pages/video_call/call_history_binding.dart';
import '../pages/video_call/video_call_page.dart';
import '../pages/video_call/video_call_binding.dart';
import '../pages/media/media_gallery_page.dart';
import '../pages/media/media_gallery_binding.dart';
import '../pages/media/sticker_gallery_page.dart';
import '../pages/media/sticker_gallery_binding.dart';

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

    // Chat Pages
    GetPage(
      name: AppRoutes.chats,
      page: () => const ChatListPage(),
      binding: ChatListBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.chatDetail,
      page: () => const ChatDetailPage(),
      binding: ChatDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Video Call Pages
    GetPage(
      name: AppRoutes.calls,
      page: () => const CallHistoryPage(),
      binding: CallHistoryBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.videoCall,
      page: () => const VideoCallPage(),
      binding: VideoCallBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Media Pages
    GetPage(
      name: AppRoutes.gallery,
      page: () => const MediaGalleryPage(),
      binding: MediaGalleryBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.stickers,
      page: () => const StickerGalleryPage(),
      binding: StickerGalleryBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
