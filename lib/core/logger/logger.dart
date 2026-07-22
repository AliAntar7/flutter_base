import 'package:logger/logger.dart' as logger_package;

/// Provides the application's logging API.
///
/// Features should never interact with the `logger` package directly.
/// All logging goes through this class.
abstract final class AppLogger {
  static late final logger_package.Logger _logger;

  static bool _enabled = false;

  /// Initializes the logger.
  ///
  /// Must be called once during application bootstrap.
  static void initialize({
    required bool enableLogging,
  }) {
    _enabled = enableLogging;

    _logger = logger_package.Logger();
  }

  /// Logs a debug message.
  static void debug(
      Object message, {
        Object? error,
        StackTrace? stackTrace,
      }) {
    if (!_enabled) return;

    _logger.d(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs an informational message.
  static void info(
      Object message, {
        Object? error,
        StackTrace? stackTrace,
      }) {
    if (!_enabled) return;

    _logger.i(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a warning message.
  static void warning(
      Object message, {
        Object? error,
        StackTrace? stackTrace,
      }) {
    if (!_enabled) return;

    _logger.w(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs an error message.
  static void error(
      Object message, {
        Object? error,
        StackTrace? stackTrace,
      }) {
    if (!_enabled) return;

    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}