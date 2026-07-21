import 'package:logger/logger.dart' as logger_package;

/// Provides the application's logging API.
final class AppLogger {
  AppLogger({required bool enabled})
    : _logger = enabled ? logger_package.Logger() : null;

  final logger_package.Logger? _logger;

  /// Logs a debug message.
  void debug(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger?.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an informational message.
  void info(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger?.i(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message.
  void warning(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger?.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an error message.
  void error(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger?.e(message, error: error, stackTrace: stackTrace);
  }
}
