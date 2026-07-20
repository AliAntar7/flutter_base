import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Provides the application's strongly typed configuration values.
abstract final class AppConfig {
  static const _appNameKey = 'APP_NAME';
  static const _baseUrlKey = 'BASE_URL';
  static const _isDebugKey = 'IS_DEBUG';
  static const _enableLoggerKey = 'ENABLE_LOGGER';

  /// The configured application name.
  static String get appName => _requiredValue(_appNameKey);

  /// The configured base URL.
  static String get baseUrl => _requiredValue(_baseUrlKey);

  /// Whether debug behavior is enabled.
  static bool get isDebug => _boolValue(_isDebugKey);

  /// Whether application logging is enabled.
  static bool get enableLogger => _boolValue(_enableLoggerKey);

  static String _requiredValue(String key) {
    _ensureLoaded();
    final value = dotenv.maybeGet(key)?.trim();

    if (value == null || value.isEmpty) {
      throw StateError('Required configuration value "$key" is missing.');
    }

    return value;
  }

  static bool _boolValue(String key) {
    _ensureLoaded();
    final value = dotenv.maybeGet(key)?.trim().toLowerCase();

    return switch (value) {
      'true' || '1' => true,
      'false' || '0' => false,
      _ => false,
    };
  }

  static void _ensureLoaded() {
    if (!dotenv.isInitialized) {
      throw StateError(
        'Application configuration is unavailable because dotenv has not been loaded.',
      );
    }
  }
}
