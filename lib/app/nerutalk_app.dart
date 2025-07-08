import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../core/services/translation_service.dart';
import '../presentation/controllers/theme_controller.dart';
import '../presentation/routes/app_routes.dart';
import '../presentation/routes/app_pages.dart';

/// Main NeruTalk application widget
/// Configures GetX, theming, internationalization, and routing
class NeruTalkApp extends StatelessWidget {
  const NeruTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize theme controller
    Get.put(ThemeController(), permanent: true);

    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          // App Information
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,

          // Theming
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,

          // Internationalization
          translations: AppTranslations(),
          locale: Get.deviceLocale,
          fallbackLocale: AppTranslations.fallbackLocale,
          supportedLocales: AppTranslations.supportedLocales,

          // Routing
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,

          // Default transition
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),

          // Responsive design
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0, // Prevent font scaling
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
