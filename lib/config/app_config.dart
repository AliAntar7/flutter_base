import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'env_keys.dart';

/// Provides the application's strongly typed configuration values.
abstract final class AppConfig {
  /// The configured application name.
  static String get appName => _requiredValue(EnvKeys.appName);

  /// The configured base URL.
  static String get baseUrl => _requiredValue(EnvKeys.baseUrl);

  /// Whether debug behavior is enabled.
  static bool get isDebug => _boolValue(EnvKeys.isDebug);

  /// Whether application logging is enabled.
  static bool get enableLogger => _boolValue(EnvKeys.enableLogger);

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
