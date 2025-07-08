import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/nerutalk_app.dart';
import 'core/config/app_config.dart';
import 'core/services/translation_service.dart';
import 'core/services/network_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/profile_service.dart';
import 'core/services/settings_service.dart';

/// Main entry point of the NeruTalk application
/// Initializes all core services and dependencies before starting the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize app configuration
  AppConfig.initialize();

  // Initialize services
  await _initializeServices();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const NeruTalkApp());
}

/// Initialize all core services and dependencies
Future<void> _initializeServices() async {
  try {
    // Initialize translation service
    await AppTranslations.initializeLanguage();

    // Initialize and register core services with GetX
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<NetworkService>(NetworkService(), permanent: true);
    Get.put<NotificationService>(NotificationService(), permanent: true);
    Get.put<ProfileService>(ProfileService(), permanent: true);
    Get.put<SettingsService>(SettingsService(), permanent: true);

    // Wait for all services to be ready
    await Get.find<NetworkService>().onReady;

    print('✅ All services initialized successfully');
  } catch (e) {
    print('❌ Error initializing services: $e');
    rethrow;
  }
}
