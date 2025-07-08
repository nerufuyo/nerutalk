import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:hive/hive.dart';
import '../config/app_config.dart';
import '../constants/app_strings.dart';
import 'auth_service.dart';

/// Network service for handling API requests with offline support
/// Provides caching, retry mechanisms, and offline queue functionality
class NetworkService extends getx.GetxService {
  late Dio _dio;
  late Connectivity _connectivity;
  late Box _cacheBox;
  late Box _offlineQueueBox;

  final getx.RxBool _isOnline = false.obs;
  final getx.RxString _connectionType = 'none'.obs;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _retryTimer;

  // Queue for offline requests
  final List<OfflineRequest> _offlineQueue = [];

  /// Check if device is online
  bool get isOnline => _isOnline.value;

  /// Get current connection type
  String get connectionType => _connectionType.value;

  /// Get online status as reactive stream
  getx.RxBool get isOnlineStream => _isOnline;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeService();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _retryTimer?.cancel();
    super.onClose();
  }

  /// Initialize network service
  Future<void> _initializeService() async {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        errorMethodCount: 5,
        lineLength: 50,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );

    _connectivity = Connectivity();

    // Initialize Hive boxes for caching and offline queue
    _cacheBox = await Hive.openBox('network_cache');
    _offlineQueueBox = await Hive.openBox('offline_queue');

    await _initializeDio();
    await _initializeConnectivity();
    await _loadOfflineQueue();
  }

  /// Initialize Dio HTTP client
  Future<void> _initializeDio() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
        receiveTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
        sendTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(CacheInterceptor(_cacheBox));
    _dio.interceptors.add(LoggingInterceptor(_logger));
    _dio.interceptors.add(RetryInterceptor(_dio));
    _dio.interceptors.add(ErrorInterceptor());
  }

  /// Initialize connectivity monitoring
  Future<void> _initializeConnectivity() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    await _updateConnectionStatus(result);

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (error) {
        _logger.e('Connectivity error: $error');
      },
    );
  }

  /// Update connection status
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    final wasOnline = _isOnline.value;

    switch (result) {
      case ConnectivityResult.wifi:
        _connectionType.value = 'wifi';
        _isOnline.value = await _hasInternetConnection();
        break;
      case ConnectivityResult.mobile:
        _connectionType.value = 'mobile';
        _isOnline.value = await _hasInternetConnection();
        break;
      case ConnectivityResult.ethernet:
        _connectionType.value = 'ethernet';
        _isOnline.value = await _hasInternetConnection();
        break;
      case ConnectivityResult.none:
        _connectionType.value = 'none';
        _isOnline.value = false;
        break;
      default:
        _connectionType.value = 'unknown';
        _isOnline.value = false;
        break;
    }

    _logger.i(
      'Connection status: ${_connectionType.value}, Online: ${_isOnline.value}',
    );

    // Process offline queue when coming back online
    if (!wasOnline && _isOnline.value) {
      await _processOfflineQueue();
    }
  }

  /// Check if device has actual internet connection
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Make GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useCache = true,
    Duration? cacheMaxAge,
  }) async {
    try {
      if (!_isOnline.value && useCache) {
        // Try to get from cache when offline
        final cachedData = await _getCachedData(endpoint, queryParameters);
        if (cachedData != null) {
          return ApiResponse<T>.success(cachedData);
        }
        return ApiResponse<T>.error(
          'No internet connection and no cached data available',
        );
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>.success(response.data);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Make POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool queueWhenOffline = true,
  }) async {
    try {
      if (!_isOnline.value && queueWhenOffline) {
        // Queue request for later when offline
        await _queueOfflineRequest(
          'POST',
          endpoint,
          data: data,
          queryParameters: queryParameters,
        );
        return ApiResponse<T>.success(
          null,
          message: 'Request queued for when online',
        );
      }

      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>.success(response.data);
    } catch (e) {
      if (queueWhenOffline && _shouldQueueRequest(e)) {
        await _queueOfflineRequest(
          'POST',
          endpoint,
          data: data,
          queryParameters: queryParameters,
        );
        return ApiResponse<T>.success(
          null,
          message: 'Request queued for retry',
        );
      }
      return _handleError<T>(e);
    }
  }

  /// Make PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool queueWhenOffline = true,
  }) async {
    try {
      if (!_isOnline.value && queueWhenOffline) {
        await _queueOfflineRequest(
          'PUT',
          endpoint,
          data: data,
          queryParameters: queryParameters,
        );
        return ApiResponse<T>.success(
          null,
          message: 'Request queued for when online',
        );
      }

      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>.success(response.data);
    } catch (e) {
      if (queueWhenOffline && _shouldQueueRequest(e)) {
        await _queueOfflineRequest(
          'PUT',
          endpoint,
          data: data,
          queryParameters: queryParameters,
        );
        return ApiResponse<T>.success(
          null,
          message: 'Request queued for retry',
        );
      }
      return _handleError<T>(e);
    }
  }

  /// Make DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool queueWhenOffline = true,
  }) async {
    try {
      if (!_isOnline.value && queueWhenOffline) {
        await _queueOfflineRequest(
          'DELETE',
          endpoint,
          data: data,
          queryParameters: queryParameters,
        );
        return ApiResponse<T>.success(
          null,
          message: 'Request queued for when online',
        );
      }

      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>.success(response.data);
    } catch (e) {
      if (queueWhenOffline && _shouldQueueRequest(e)) {
        await _queueOfflineRequest(
          'DELETE',
          endpoint,
          data: data,
          queryParameters: queryParameters,
        );
        return ApiResponse<T>.success(
          null,
          message: 'Request queued for retry',
        );
      }
      return _handleError<T>(e);
    }
  }

  /// Get cached data
  Future<dynamic> _getCachedData(
    String endpoint,
    Map<String, dynamic>? queryParameters,
  ) async {
    try {
      final cacheKey = _generateCacheKey(endpoint, queryParameters);
      final cachedResponse = _cacheBox.get(cacheKey);

      if (cachedResponse != null) {
        final Map<String, dynamic> cache = Map<String, dynamic>.from(
          cachedResponse,
        );
        final int timestamp = cache['timestamp'] ?? 0;
        final DateTime cacheTime = DateTime.fromMillisecondsSinceEpoch(
          timestamp,
        );

        // Check if cache is still valid
        if (DateTime.now().difference(cacheTime).inSeconds <=
            AppConfig.cacheMaxAge) {
          _logger.i('Using cached data for: $endpoint');
          return cache['data'];
        } else {
          // Remove expired cache
          await _cacheBox.delete(cacheKey);
        }
      }

      return null;
    } catch (e) {
      _logger.e('Error getting cached data: $e');
      return null;
    }
  }

  /// Generate cache key
  String _generateCacheKey(
    String endpoint,
    Map<String, dynamic>? queryParameters,
  ) {
    final buffer = StringBuffer(endpoint);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      buffer.write('?');
      buffer.write(Uri(queryParameters: queryParameters).query);
    }
    return buffer.toString();
  }

  /// Queue offline request
  Future<void> _queueOfflineRequest(
    String method,
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final request = OfflineRequest(
        method: method,
        endpoint: endpoint,
        data: data,
        queryParameters: queryParameters,
        timestamp: DateTime.now(),
      );

      _offlineQueue.add(request);
      await _saveOfflineQueue();

      _logger.i('Queued offline request: $method $endpoint');
    } catch (e) {
      _logger.e('Error queuing offline request: $e');
    }
  }

  /// Check if request should be queued
  bool _shouldQueueRequest(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.connectionError;
    }
    return false;
  }

  /// Process offline queue
  Future<void> _processOfflineQueue() async {
    if (_offlineQueue.isEmpty) return;

    _logger.i('Processing ${_offlineQueue.length} offline requests');

    final requestsToRemove = <OfflineRequest>[];

    for (final request in List.from(_offlineQueue)) {
      try {
        Response response;

        switch (request.method.toUpperCase()) {
          case 'GET':
            response = await _dio.get(
              request.endpoint,
              queryParameters: request.queryParameters,
            );
            break;
          case 'POST':
            response = await _dio.post(
              request.endpoint,
              data: request.data,
              queryParameters: request.queryParameters,
            );
            break;
          case 'PUT':
            response = await _dio.put(
              request.endpoint,
              data: request.data,
              queryParameters: request.queryParameters,
            );
            break;
          case 'DELETE':
            response = await _dio.delete(
              request.endpoint,
              data: request.data,
              queryParameters: request.queryParameters,
            );
            break;
          default:
            continue;
        }

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          requestsToRemove.add(request);
          _logger.i(
            'Successfully processed offline request: ${request.method} ${request.endpoint}',
          );
        }
      } catch (e) {
        _logger.e(
          'Failed to process offline request: ${request.method} ${request.endpoint}, Error: $e',
        );

        // Remove old requests (older than 24 hours)
        if (DateTime.now().difference(request.timestamp).inHours > 24) {
          requestsToRemove.add(request);
        }
      }
    }

    // Remove processed requests
    for (final request in requestsToRemove) {
      _offlineQueue.remove(request);
    }

    await _saveOfflineQueue();
  }

  /// Save offline queue to persistent storage
  Future<void> _saveOfflineQueue() async {
    try {
      final queueData = _offlineQueue
          .map((request) => request.toJson())
          .toList();
      await _offlineQueueBox.put('queue', queueData);
    } catch (e) {
      _logger.e('Error saving offline queue: $e');
    }
  }

  /// Load offline queue from persistent storage
  Future<void> _loadOfflineQueue() async {
    try {
      final queueData = _offlineQueueBox.get('queue');
      if (queueData != null && queueData is List) {
        _offlineQueue.clear();
        for (final item in queueData) {
          if (item is Map<String, dynamic>) {
            _offlineQueue.add(
              OfflineRequest.fromJson(Map<String, dynamic>.from(item)),
            );
          }
        }
        _logger.i('Loaded ${_offlineQueue.length} offline requests');
      }
    } catch (e) {
      _logger.e('Error loading offline queue: $e');
    }
  }

  /// Handle errors
  ApiResponse<T> _handleError<T>(dynamic error) {
    String message = 'An unknown error occurred';
    int? statusCode;

    if (error is DioException) {
      statusCode = error.response?.statusCode;

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message =
              'Connection timeout. Please check your internet connection.';
          break;
        case DioExceptionType.badResponse:
          message = error.response?.data?['message'] ?? 'Server error occurred';
          break;
        case DioExceptionType.cancel:
          message = 'Request was cancelled';
          break;
        case DioExceptionType.connectionError:
          message = 'Connection error. Please check your internet connection.';
          break;
        case DioExceptionType.badCertificate:
          message = 'Certificate error occurred';
          break;
        case DioExceptionType.unknown:
          message = error.message ?? 'Unknown network error';
          break;
      }
    }

    _logger.e('Network error: $message', error, StackTrace.current);
    return ApiResponse<T>.error(message, statusCode: statusCode);
  }

  /// Clear cache
  Future<void> clearCache() async {
    try {
      await _cacheBox.clear();
      _logger.i('Cache cleared successfully');
    } catch (e) {
      _logger.e('Error clearing cache: $e');
    }
  }

  /// Clear offline queue
  Future<void> clearOfflineQueue() async {
    try {
      _offlineQueue.clear();
      await _offlineQueueBox.clear();
      _logger.i('Offline queue cleared successfully');
    } catch (e) {
      _logger.e('Error clearing offline queue: $e');
    }
  }

  /// Get cache size
  Future<double> getCacheSize() async {
    try {
      // This is a simplified calculation
      // In a real app, you might want to calculate actual file sizes
      return _cacheBox.length.toDouble();
    } catch (e) {
      _logger.e('Error getting cache size: $e');
      return 0.0;
    }
  }

  /// Get offline queue size
  int getOfflineQueueSize() {
    return _offlineQueue.length;
  }
}

/// API Response wrapper class
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  ApiResponse._({
    this.data,
    this.message,
    required this.success,
    this.statusCode,
  });

  factory ApiResponse.success(T? data, {String? message}) {
    return ApiResponse._(data: data, message: message, success: true);
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse._(
      message: message,
      success: false,
      statusCode: statusCode,
    );
  }
}

/// Offline request model
class OfflineRequest {
  final String method;
  final String endpoint;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final DateTime timestamp;

  OfflineRequest({
    required this.method,
    required this.endpoint,
    this.data,
    this.queryParameters,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'endpoint': endpoint,
      'data': data,
      'queryParameters': queryParameters,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory OfflineRequest.fromJson(Map<String, dynamic> json) {
    return OfflineRequest(
      method: json['method'],
      endpoint: json['endpoint'],
      data: json['data'],
      queryParameters: json['queryParameters'] != null
          ? Map<String, dynamic>.from(json['queryParameters'])
          : null,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}

/// Authentication interceptor
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authService = getx.Get.find<AuthService>();
    final token = await authService.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final authService = getx.Get.find<AuthService>();
      final refreshed = await authService.refreshToken();

      if (refreshed) {
        // Retry the request with new token
        final token = await authService.getAccessToken();
        if (token != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          final dio = Dio();
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        }
      }

      // If refresh failed, logout user
      await authService.logout();
    }

    handler.next(err);
  }
}

/// Cache interceptor
class CacheInterceptor extends Interceptor {
  final Box _cacheBox;

  CacheInterceptor(this._cacheBox);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.statusCode == 200) {
      try {
        final cacheKey = _generateCacheKey(
          response.requestOptions.path,
          response.requestOptions.queryParameters,
        );

        final cacheData = {
          'data': response.data,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };

        await _cacheBox.put(cacheKey, cacheData);
      } catch (e) {
        // Cache error shouldn't affect response
      }
    }

    handler.next(response);
  }

  String _generateCacheKey(
    String endpoint,
    Map<String, dynamic> queryParameters,
  ) {
    final buffer = StringBuffer(endpoint);
    if (queryParameters.isNotEmpty) {
      buffer.write('?');
      buffer.write(Uri(queryParameters: queryParameters).query);
    }
    return buffer.toString();
  }
}

/// Logging interceptor
class LoggingInterceptor extends Interceptor {
  final Logger _logger;

  LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.isLoggingEnabled) {
      _logger.i('🚀 ${options.method} ${options.uri}');
      if (options.data != null) {
        _logger.d('📤 Request data: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppConfig.isLoggingEnabled) {
      _logger.i('✅ ${response.statusCode} ${response.requestOptions.uri}');
      _logger.d('📥 Response data: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.isLoggingEnabled) {
      _logger.e('❌ ${err.response?.statusCode} ${err.requestOptions.uri}');
      _logger.e('Error: ${err.message}');
    }
    handler.next(err);
  }
}

/// Retry interceptor
class RetryInterceptor extends Interceptor {
  final Dio _dio;

  RetryInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) &&
        (err.requestOptions.extra['retryCount'] ?? 0) <
            AppConfig.maxRetryAttempts) {
      final retryCount = (err.requestOptions.extra['retryCount'] ?? 0) + 1;
      err.requestOptions.extra['retryCount'] = retryCount;

      await Future.delayed(
        Duration(milliseconds: AppConfig.wsReconnectDelay * retryCount),
      );

      try {
        final response = await _dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Continue with original error
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.type == DioExceptionType.badResponse &&
            err.response?.statusCode != null &&
            err.response!.statusCode! >= 500);
  }
}

/// Error interceptor
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle common error responses
    if (err.response?.data is Map<String, dynamic>) {
      final errorData = err.response!.data as Map<String, dynamic>;
      if (errorData.containsKey('message')) {
        err = err.copyWith(message: errorData['message']);
      }
    }

    handler.next(err);
  }
}
