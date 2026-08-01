import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_exception.dart';
import 'api_exception_mapper.dart';
import 'api_result.dart';

/// Dio implementation of [ApiClient].
final class DioApiClient implements ApiClient {
  DioApiClient({
    required Dio dio,
    required ApiExceptionMapper exceptionMapper,
  })  : _dio = dio,
        _exceptionMapper = exceptionMapper;

  final Dio _dio;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _request(
      request: () => _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<ApiResult<T>> post<T>({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _request(
      request: () => _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<ApiResult<T>> put<T>({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _request(
      request: () => _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<ApiResult<T>> patch<T>({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _request(
      request: () => _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<ApiResult<T>> delete<T>({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _request(
      request: () => _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  Future<ApiResult<T>> _request<T>({
    required Future<Response<T>> Function() request,
  }) async {
    try {
      final response = await request();

      final data = response.data;

      if (data == null) {
        return Failure(
          ApiException(
            message: 'The server returned an empty response.',
            statusCode: response.statusCode,
          ),
        );
      }

      return Success(data);
    } on DioException catch (exception) {
      return Failure(
        _exceptionMapper.map(exception),
      );
    } catch (exception, stackTrace) {
      return Failure(
        ApiException(
          message: 'An unexpected error occurred.',
          cause: exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}