import 'package:flutter/foundation.dart';
import '../constants/app_strings.dart';

/// Application configuration class
/// Manages environment-specific settings and feature flags
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // Environment configuration
  static const String _environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  // API Configuration
  static const String _baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: AppStrings.baseUrl,
  );

  static const String _wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: AppStrings.wsBaseUrl,
  );

  // Feature flags
  static const bool _enableVideoCall = bool.fromEnvironment(
    'ENABLE_VIDEO_CALL',
    defaultValue: true,
  );

  static const bool _enableLocationSharing = bool.fromEnvironment(
    'ENABLE_LOCATION_SHARING',
    defaultValue: true,
  );

  static const bool _enableFileSharing = bool.fromEnvironment(
    'ENABLE_FILE_SHARING',
    defaultValue: true,
  );

  static const bool _enablePushNotifications = bool.fromEnvironment(
    'ENABLE_PUSH_NOTIFICATIONS',
    defaultValue: true,
  );

  // Debug configuration
  static const bool _enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  static const bool _enableCrashlytics = bool.fromEnvironment(
    'ENABLE_CRASHLYTICS',
    defaultValue: false,
  );

  static const bool _enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  // Performance configuration
  static const int _apiTimeoutSeconds = int.fromEnvironment(
    'API_TIMEOUT_SECONDS',
    defaultValue: AppStrings.connectionTimeout,
  );

  static const int _maxRetryAttempts = int.fromEnvironment(
    'MAX_RETRY_ATTEMPTS',
    defaultValue: AppStrings.maxRetryAttempts,
  );

  static const int _cacheMaxAge = int.fromEnvironment(
    'CACHE_MAX_AGE_SECONDS',
    defaultValue: AppStrings.cacheMaxAge,
  );

  // File upload configuration
  static const int _maxFileSizeMB = int.fromEnvironment(
    'MAX_FILE_SIZE_MB',
    defaultValue: AppStrings.maxImageSizeMB,
  );

  // WebSocket configuration
  static const int _wsReconnectDelay = int.fromEnvironment(
    'WS_RECONNECT_DELAY_MS',
    defaultValue: AppStrings.retryDelay,
  );

  static const int _wsMaxReconnectAttempts = int.fromEnvironment(
    'WS_MAX_RECONNECT_ATTEMPTS',
    defaultValue: AppStrings.maxRetryAttempts,
  );

  // Pagination configuration
  static const int _defaultPageSize = int.fromEnvironment(
    'DEFAULT_PAGE_SIZE',
    defaultValue: AppStrings.defaultPageSize,
  );

  static const int _maxPageSize = int.fromEnvironment(
    'MAX_PAGE_SIZE',
    defaultValue: AppStrings.maxPageSize,
  );

  // Public getters for accessing configuration values

  /// Current environment (development, staging, production)
  static String get environment => _environment;

  /// Check if app is running in development mode
  static bool get isDevelopment => _environment == 'development';

  /// Check if app is running in staging mode
  static bool get isStaging => _environment == 'staging';

  /// Check if app is running in production mode
  static bool get isProduction => _environment == 'production';

  /// Check if app is running in debug mode
  static bool get isDebugMode => kDebugMode;

  /// Check if app is running in release mode
  static bool get isReleaseMode => kReleaseMode;

  /// Base URL for API endpoints
  static String get baseUrl => _baseUrl;

  /// Base URL for WebSocket connections
  static String get wsBaseUrl => _wsBaseUrl;

  /// Check if video call feature is enabled
  static bool get isVideoCallEnabled => _enableVideoCall;

  /// Check if location sharing feature is enabled
  static bool get isLocationSharingEnabled => _enableLocationSharing;

  /// Check if file sharing feature is enabled
  static bool get isFileSharingEnabled => _enableFileSharing;

  /// Check if push notifications feature is enabled
  static bool get isPushNotificationsEnabled => _enablePushNotifications;

  /// Check if logging is enabled
  static bool get isLoggingEnabled => _enableLogging && (isDevelopment || isStaging);

  /// Check if crashlytics is enabled
  static bool get isCrashlyticsEnabled => _enableCrashlytics && isProduction;

  /// Check if analytics is enabled
  static bool get isAnalyticsEnabled => _enableAnalytics && isProduction;

  /// API timeout in seconds
  static int get apiTimeoutSeconds => _apiTimeoutSeconds;

  /// Maximum retry attempts for failed requests
  static int get maxRetryAttempts => _maxRetryAttempts;

  /// Cache maximum age in seconds
  static int get cacheMaxAge => _cacheMaxAge;

  /// Maximum file size in MB
  static int get maxFileSizeMB => _maxFileSizeMB;

  /// Maximum file size in bytes
  static int get maxFileSizeBytes => _maxFileSizeMB * 1024 * 1024;

  /// WebSocket reconnect delay in milliseconds
  static int get wsReconnectDelay => _wsReconnectDelay;

  /// Maximum WebSocket reconnection attempts
  static int get wsMaxReconnectAttempts => _wsMaxReconnectAttempts;

  /// Default page size for pagination
  static int get defaultPageSize => _defaultPageSize;

  /// Maximum page size for pagination
  static int get maxPageSize => _maxPageSize;

  /// Get app info string for debugging
  static String get appInfo {
    return '''
    App: ${AppStrings.appName}
    Version: ${AppStrings.appVersion}
    Environment: $environment
    Debug Mode: $isDebugMode
    Base URL: $baseUrl
    WebSocket URL: $wsBaseUrl
    ''';
  }

  /// Get feature flags status
  static Map<String, bool> get featureFlags {
    return {
      AppStrings.videoCallFeature: isVideoCallEnabled,
      AppStrings.locationFeature: isLocationSharingEnabled,
      AppStrings.fileShareFeature: isFileSharingEnabled,
      AppStrings.pushNotificationFeature: isPushNotificationsEnabled,
    };
  }

  /// Get performance configuration
  static Map<String, int> get performanceConfig {
    return {
      'apiTimeoutSeconds': apiTimeoutSeconds,
      'maxRetryAttempts': maxRetryAttempts,
      'cacheMaxAge': cacheMaxAge,
      'maxFileSizeMB': maxFileSizeMB,
      'wsReconnectDelay': wsReconnectDelay,
      'wsMaxReconnectAttempts': wsMaxReconnectAttempts,
      'defaultPageSize': defaultPageSize,
      'maxPageSize': maxPageSize,
    };
  }

  /// Validate configuration
  static bool validateConfig() {
    // Validate required configuration values
    if (baseUrl.isEmpty) {
      throw Exception('Base URL cannot be empty');
    }

    if (wsBaseUrl.isEmpty) {
      throw Exception('WebSocket Base URL cannot be empty');
    }

    if (apiTimeoutSeconds <= 0) {
      throw Exception('API timeout must be greater than 0');
    }

    if (maxRetryAttempts < 0) {
      throw Exception('Max retry attempts cannot be negative');
    }

    if (maxFileSizeMB <= 0) {
      throw Exception('Max file size must be greater than 0');
    }

    if (defaultPageSize <= 0 || defaultPageSize > maxPageSize) {
      throw Exception('Invalid page size configuration');
    }

    return true;
  }

  /// Initialize configuration
  static void initialize() {
    try {
      validateConfig();
      
      if (isLoggingEnabled) {
        print('🚀 App Configuration Initialized');
        print(appInfo);
        print('🎛️ Feature Flags: $featureFlags');
        print('⚡ Performance Config: $performanceConfig');
      }
    } catch (e) {
      print('❌ Configuration Error: $e');
      rethrow;
    }
  }

  /// Get API endpoint URL
  static String getApiEndpoint(String endpoint) {
    if (endpoint.startsWith('/')) {
      return '$baseUrl$endpoint';
    }
    return '$baseUrl/$endpoint';
  }

  /// Get WebSocket endpoint URL
  static String getWsEndpoint([String? endpoint]) {
    if (endpoint != null) {
      if (endpoint.startsWith('/')) {
        return '$wsBaseUrl$endpoint';
      }
      return '$wsBaseUrl/$endpoint';
    }
    return wsBaseUrl;
  }

  /// Check if feature is enabled
  static bool isFeatureEnabled(String feature) {
    switch (feature) {
      case AppStrings.videoCallFeature:
        return isVideoCallEnabled;
      case AppStrings.locationFeature:
        return isLocationSharingEnabled;
      case AppStrings.fileShareFeature:
        return isFileSharingEnabled;
      case AppStrings.pushNotificationFeature:
        return isPushNotificationsEnabled;
      default:
        return false;
    }
  }

  /// Get environment-specific database name
  static String get databaseName {
    switch (environment) {
      case 'development':
        return 'nerutalk_dev.db';
      case 'staging':
        return 'nerutalk_staging.db';
      case 'production':
        return 'nerutalk.db';
      default:
        return 'nerutalk.db';
    }
  }

  /// Get environment-specific log level
  static String get logLevel {
    if (isDevelopment) {
      return 'debug';
    } else if (isStaging) {
      return 'info';
    } else {
      return 'error';
    }
  }

  /// Should show debug information in UI
  static bool get showDebugInfo => isDevelopment || isStaging;

  /// Enable/disable specific features at runtime (for testing)
  static final Map<String, bool> _runtimeFeatureFlags = {};

  /// Set feature flag at runtime
  static void setFeatureFlag(String feature, bool enabled) {
    if (isDevelopment || isStaging) {
      _runtimeFeatureFlags[feature] = enabled;
    }
  }

  /// Get runtime feature flag
  static bool? getRuntimeFeatureFlag(String feature) {
    return _runtimeFeatureFlags[feature];
  }

  /// Check if feature is enabled (including runtime flags)
  static bool isFeatureEnabledWithRuntime(String feature) {
    final runtimeFlag = getRuntimeFeatureFlag(feature);
    if (runtimeFlag != null) {
      return runtimeFlag;
    }
    return isFeatureEnabled(feature);
  }

  /// Reset all runtime feature flags
  static void resetRuntimeFeatureFlags() {
    _runtimeFeatureFlags.clear();
  }
}
