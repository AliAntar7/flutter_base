/// Represents a normalized network exception.
///
/// The networking layer converts package-specific exceptions
/// (such as Dio exceptions) into this class before exposing
/// them to the rest of the application.
final class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.cause,
    this.stackTrace,
  });

  /// Human-readable error message.
  final String message;

  /// HTTP status code returned by the server.
  final int? statusCode;

  /// Optional server-defined error code.
  final String? errorCode;

  /// Original exception.
  final Object? cause;

  /// Original stack trace.
  final StackTrace? stackTrace;

  @override
  String toString() {
    return '''
ApiException(
  message: $message,
  statusCode: $statusCode,
  errorCode: $errorCode,
)
''';
  }
}