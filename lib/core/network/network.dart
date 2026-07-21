import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../logger/logger.dart';
import '../storage/storage.dart';

/// Provides the application's HTTP API without exposing Dio.
abstract final class Network {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _refreshPath = '/auth/refresh';
  static const _accessTokenField = 'access_token';
  static const _refreshTokenField = 'refresh_token';
  static const _retryCountKey = 'network_retry_count';
  static const _tokenRetryKey = 'network_token_retry';
  static const _skipAuthKey = 'network_skip_auth';
  static const _skipCacheKey = 'network_skip_cache';
  static const _maxRetries = 3;
  static const _cacheTtl = Duration(minutes: 5);

  static Dio? _dio;
  static Dio? _refreshDio;
  static bool _wasInitialized = false;
  static Future<String?>? _refreshFuture;
  static final Map<String, ({Object? data, DateTime expiresAt})> _cache = {};

  /// Initializes the HTTP client once during application startup.
  static Future<void> initialize() async {
    if (_wasInitialized) {
      throw StateError('The network client has already been initialized.');
    }

    final baseUrl = AppConfig.baseUrl;
    _dio = Dio(_options(baseUrl));
    _refreshDio = Dio(_options(baseUrl));
    _dio!.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          await _attachAccessToken(options);
          _serveCachedResponse(options, handler);
        },
        onResponse: (response, handler) {
          _cacheResponse(response);
          handler.next(response);
        },
        onError: (error, handler) async {
          await _handleError(error, handler);
        },
      ),
    );
    _wasInitialized = true;
  }

  /// Sends a GET request and returns its decoded response data.
  static Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T? Function(Object? data)? decoder,
    bool useCache = true,
  }) {
    return _request<T>(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      decoder: decoder,
      useCache: useCache,
    );
  }

  /// Sends a POST request and returns its decoded response data.
  static Future<T?> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T? Function(Object? data)? decoder,
  }) {
    return _request<T>(
      method: 'POST',
      path: path,
      data: data,
      queryParameters: queryParameters,
      decoder: decoder,
    );
  }

  /// Sends a PUT request and returns its decoded response data.
  static Future<T?> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T? Function(Object? data)? decoder,
  }) {
    return _request<T>(
      method: 'PUT',
      path: path,
      data: data,
      queryParameters: queryParameters,
      decoder: decoder,
    );
  }

  /// Sends a DELETE request and returns its decoded response data.
  static Future<T?> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T? Function(Object? data)? decoder,
  }) {
    return _request<T>(
      method: 'DELETE',
      path: path,
      data: data,
      queryParameters: queryParameters,
      decoder: decoder,
    );
  }

  /// Removes all cached GET responses.
  static void clearCache() {
    _cache.clear();
  }

  static Future<T?> _request<T>({
    required String method,
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    T? Function(Object? data)? decoder,
    bool useCache = false,
  }) async {
    final response = await _requireDio().request<Object?>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(method: method, extra: {_skipCacheKey: !useCache}),
    );

    final responseData = response.data;
    return decoder == null ? responseData as T? : decoder(responseData);
  }

  static BaseOptions _options(String baseUrl) {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
    );
  }

  static Future<void> _attachAccessToken(RequestOptions options) async {
    if (options.extra[_skipAuthKey] == true) {
      return;
    }

    final accessToken = await Storage.readSecure(_accessTokenKey);
    if (accessToken == null || accessToken.isEmpty) {
      return;
    }

    options.headers['Authorization'] = 'Bearer $accessToken';
  }

  static void _serveCachedResponse(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (options.method.toUpperCase() != 'GET' ||
        options.extra[_skipCacheKey] == true) {
      handler.next(options);
      return;
    }

    final cacheKey = options.uri.toString();
    final cached = _cache[cacheKey];
    if (cached == null) {
      handler.next(options);
      return;
    }

    if (cached.expiresAt.isBefore(DateTime.now())) {
      _cache.remove(cacheKey);
      handler.next(options);
      return;
    }

    handler.resolve(
      Response<Object?>(
        requestOptions: options,
        data: cached.data,
        statusCode: 200,
      ),
    );
  }

  static void _cacheResponse(Response<dynamic> response) {
    final options = response.requestOptions;
    final method = options.method.toUpperCase();
    final statusCode = response.statusCode ?? 0;

    if (!_isSuccessful(statusCode)) {
      return;
    }

    if (method == 'GET' && options.extra[_skipCacheKey] != true) {
      _cache[options.uri.toString()] = (
        data: response.data,
        expiresAt: DateTime.now().add(_cacheTtl),
      );
      return;
    }

    if (_isMutation(method)) {
      clearCache();
    }
  }

  static Future<void> _handleError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final options = error.requestOptions;

    if (_isUnauthorized(error) &&
        options.extra[_skipAuthKey] != true &&
        options.extra[_tokenRetryKey] != true) {
      final accessToken = await _refreshAccessToken();
      if (accessToken != null) {
        options.extra[_tokenRetryKey] = true;
        options.headers['Authorization'] = 'Bearer $accessToken';

        try {
          final response = await _requireDio().fetch<Object?>(options);
          handler.resolve(response);
          return;
        } on DioException catch (retryError) {
          handler.next(retryError);
          return;
        }
      }
    }

    if (_shouldRetry(error)) {
      final retryCount = (options.extra[_retryCountKey] as int?) ?? 0;
      if (retryCount < _maxRetries) {
        options.extra[_retryCountKey] = retryCount + 1;
        await Future<void>.delayed(
          Duration(milliseconds: 250 * (1 << retryCount)),
        );

        try {
          final response = await _requireDio().fetch<Object?>(options);
          handler.resolve(response);
          return;
        } on DioException catch (retryError) {
          handler.next(retryError);
          return;
        }
      }
    }

    handler.next(error);
  }

  static Future<String?> _refreshAccessToken() {
    final currentRefresh = _refreshFuture;
    if (currentRefresh != null) {
      return currentRefresh;
    }

    final refreshFuture = _performTokenRefresh();
    final trackedFuture = refreshFuture.whenComplete(() {
      _refreshFuture = null;
    });
    _refreshFuture = trackedFuture;
    return trackedFuture;
  }

  static Future<String?> _performTokenRefresh() async {
    final refreshToken = await Storage.readSecure(_refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final response = await _refreshDio!.post<Object?>(
        _refreshPath,
        data: {_refreshTokenField: refreshToken},
      );
      final responseData = response.data;

      if (responseData is! Map) {
        await _clearTokens();
        return null;
      }

      final accessToken = responseData[_accessTokenField];
      if (accessToken is! String || accessToken.isEmpty) {
        await _clearTokens();
        return null;
      }

      await Storage.writeSecure(_accessTokenKey, accessToken);

      final newRefreshToken = responseData[_refreshTokenField];
      if (newRefreshToken is String && newRefreshToken.isNotEmpty) {
        await Storage.writeSecure(_refreshTokenKey, newRefreshToken);
      }

      return accessToken;
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Token refresh failed.',
        error: error,
        stackTrace: stackTrace,
      );
      await _clearTokens();
      return null;
    }
  }

  static Future<void> _clearTokens() async {
    await Storage.deleteSecure(_accessTokenKey);
    await Storage.deleteSecure(_refreshTokenKey);
  }

  static bool _shouldRetry(DioException error) {
    final method = error.requestOptions.method.toUpperCase();
    final isIdempotent = {
      'GET',
      'HEAD',
      'OPTIONS',
      'PUT',
      'DELETE',
    }.contains(method);
    if (!isIdempotent) {
      return false;
    }

    final statusCode = error.response?.statusCode;
    final isServerError = statusCode != null && statusCode >= 500;
    final isTemporaryFailure = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      _ => false,
    };

    return isServerError || isTemporaryFailure;
  }

  static bool _isUnauthorized(DioException error) {
    return error.response?.statusCode == 401;
  }

  static bool _isMutation(String method) {
    return {'POST', 'PUT', 'PATCH', 'DELETE'}.contains(method);
  }

  static bool _isSuccessful(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  static Dio _requireDio() {
    if (!_wasInitialized) {
      throw StateError('The network client must be initialized first.');
    }

    return _dio!;
  }
}
