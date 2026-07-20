import 'package:logger/logger.dart' as logger_package;

/// Provides the application's logging API.
abstract final class AppLogger {
  static logger_package.Logger? _logger;
  static bool _wasInitialized = false;
  static bool _isEnabled = false;

  /// Initializes logging once during application startup.
  static void initialize({required bool enabled}) {
    if (_wasInitialized) {
      throw StateError('The application logger has already been initialized.');
    }

    _isEnabled = enabled;
    _logger = enabled ? logger_package.Logger() : null;
    _wasInitialized = true;
  }

  /// Logs a debug message.
  static void debug(Object message, {Object? error, StackTrace? stackTrace}) {
    if (_canLog) {
      _logger!.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Logs an informational message.
  static void info(Object message, {Object? error, StackTrace? stackTrace}) {
    if (_canLog) {
      _logger!.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Logs a warning message.
  static void warning(Object message, {Object? error, StackTrace? stackTrace}) {
    if (_canLog) {
      _logger!.w(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Logs an error message.
  static void error(Object message, {Object? error, StackTrace? stackTrace}) {
    if (_canLog) {
      _logger!.e(message, error: error, stackTrace: stackTrace);
    }
  }

  static bool get _canLog => _wasInitialized && _isEnabled;
}
