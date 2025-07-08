import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/network_service.dart';
import '../../../core/config/app_config.dart';
import '../../routes/app_routes.dart';

/// Splash controller for handling app initialization
/// Manages startup tasks and navigation to appropriate screen
class SplashController extends GetxController {
  // Observable variables
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString loadingMessage = 'Initializing...'.obs;
  
  // Services
  late AuthService _authService;
  late NetworkService _networkService;
  
  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    _startInitialization();
  }

  /// Initialize required services
  void _initializeServices() {
    _authService = Get.find<AuthService>();
    _networkService = Get.find<NetworkService>();
  }

  /// Start app initialization process
  Future<void> _startInitialization() async {
    try {
      await _performInitializationTasks();
      await _navigateToNextScreen();
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  /// Perform all initialization tasks
  Future<void> _performInitializationTasks() async {
    // Task 1: Check app configuration
    loadingMessage.value = 'Checking configuration...';
    await Future.delayed(const Duration(milliseconds: 500));
    _validateAppConfig();

    // Task 2: Check network connectivity
    loadingMessage.value = 'Checking network...';
    await Future.delayed(const Duration(milliseconds: 500));
    await _checkNetworkConnectivity();

    // Task 3: Initialize local database
    loadingMessage.value = 'Setting up local storage...';
    await Future.delayed(const Duration(milliseconds: 500));
    await _initializeLocalStorage();

    // Task 4: Check authentication status
    loadingMessage.value = 'Checking authentication...';
    await Future.delayed(const Duration(milliseconds: 500));
    await _checkAuthenticationStatus();

    // Task 5: Load user preferences
    loadingMessage.value = 'Loading preferences...';
    await Future.delayed(const Duration(milliseconds: 500));
    await _loadUserPreferences();

    // Task 6: Check for app updates
    loadingMessage.value = 'Checking for updates...';
    await Future.delayed(const Duration(milliseconds: 500));
    await _checkForUpdates();

    // Final delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  /// Validate app configuration
  void _validateAppConfig() {
    try {
      AppConfig.validateConfig();
    } catch (e) {
      throw Exception('Configuration validation failed: $e');
    }
  }

  /// Check network connectivity
  Future<void> _checkNetworkConnectivity() async {
    try {
      // Network service will handle connectivity checks
      // This is just a placeholder for additional network setup
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      // Network issues are not critical for app startup
      // The app can work in offline mode
      print('Network check warning: $e');
    }
  }

  /// Initialize local storage and database
  Future<void> _initializeLocalStorage() async {
    try {
      // TODO: Initialize Hive boxes, SQLite database, etc.
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      throw Exception('Local storage initialization failed: $e');
    }
  }

  /// Check user authentication status
  Future<void> _checkAuthenticationStatus() async {
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      print('User authentication status: $isAuthenticated');
    } catch (e) {
      print('Authentication check warning: $e');
    }
  }

  /// Load user preferences and settings
  Future<void> _loadUserPreferences() async {
    try {
      // TODO: Load theme, language, notification settings, etc.
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      print('Preferences loading warning: $e');
    }
  }

  /// Check for app updates
  Future<void> _checkForUpdates() async {
    try {
      // TODO: Check for app updates from store or server
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      print('Update check warning: $e');
    }
  }

  /// Navigate to the appropriate next screen
  Future<void> _navigateToNextScreen() async {
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      final isFirstTime = await _isFirstTimeUser();

      if (isFirstTime) {
        // First time user - show onboarding
        Get.offAllNamed(AppRoutes.onboarding);
      } else if (isAuthenticated) {
        // Authenticated user - go to home
        Get.offAllNamed(AppRoutes.home);
      } else {
        // Non-authenticated user - go to login
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      throw Exception('Navigation failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if this is the first time the user opens the app
  Future<bool> _isFirstTimeUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
      return !onboardingCompleted;
    } catch (e) {
      // If there's an error, assume it's first time
      return true;
    }
  }

  /// Handle initialization errors
  void _handleInitializationError(dynamic error) {
    isLoading.value = false;
    errorMessage.value = _getErrorMessage(error);
    print('Initialization error: $error');
  }

  /// Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    } else if (error is String) {
      return error;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Retry initialization process
  Future<void> retry() async {
    errorMessage.value = '';
    isLoading.value = true;
    loadingMessage.value = 'Retrying...';
    
    await Future.delayed(const Duration(milliseconds: 500));
    await _startInitialization();
  }

  /// Skip initialization and go to main app
  void skipToMain() {
    isLoading.value = false;
    errorMessage.value = '';
    Get.offAllNamed(AppRoutes.login);
  }

  /// Force navigation to login (for emergency situations)
  void forceToLogin() {
    isLoading.value = false;
    errorMessage.value = '';
    Get.offAllNamed(AppRoutes.login);
  }

  /// Get initialization progress as percentage
  double get initializationProgress {
    // This could be enhanced to show actual progress
    // For now, return indeterminate progress
    return isLoading.value ? 0.0 : 1.0;
  }

  /// Check if critical error occurred
  bool get hasCriticalError {
    return errorMessage.value.contains('Configuration') ||
           errorMessage.value.contains('Local storage') ||
           errorMessage.value.contains('Navigation');
  }

  /// Get current initialization step
  String get currentStep {
    return loadingMessage.value;
  }
}
