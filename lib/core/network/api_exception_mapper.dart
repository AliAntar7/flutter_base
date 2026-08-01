import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Converts Dio exceptions into application exceptions.
///
/// This class isolates Dio-specific error handling from the rest
/// of the application. The networking layer should always expose
/// [ApiException] instead of [DioException].
final class ApiExceptionMapper {
  const ApiExceptionMapper();

  ApiException map(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timeout.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: exception.stackTrace,
        );

      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Request timeout.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: exception.stackTrace,
        );

      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Response timeout.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: exception.stackTrace,
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Invalid server certificate.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: exception.stackTrace,
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: exception.stackTrace,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection.',
          cause: exception,
          stackTrace: exception.stackTrace,
        );

      case DioExceptionType.badResponse:
        return _mapBadResponse(exception);

      case DioExceptionType.unknown:
        return ApiException(
          message: 'Unexpected network error.',
          cause: exception,
          stackTrace: exception.stackTrace,
        );
      case DioExceptionType.transformTimeout:
        return ApiException(
          message: 'Response timeout.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: exception.stackTrace,
        );
    }
  }

  ApiException _mapBadResponse(DioException exception) {
    final response = exception.response;

    final data = response?.data;

    String? message;
    String? errorCode;

    if (data is Map<String, dynamic>) {
      message = data['message']?.toString();
      errorCode = data['code']?.toString();
    }

    return ApiException(
      message: message ?? 'Server error.',
      statusCode: response?.statusCode,
      errorCode: errorCode,
      cause: exception,
      stackTrace: exception.stackTrace,
    );
  }
}