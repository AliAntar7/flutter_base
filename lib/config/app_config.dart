import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'env_keys.dart';

/// Provides strongly typed access to the application's configuration.
///
/// This class is intentionally static because configuration is global.
/// There is no need to create an instance or register it in GetIt.
abstract final class AppConfig {
  /// Application name.
  static String get appName => _getValue(EnvKeys.appName);

  /// Base API URL.
  static String get baseUrl => _getValue(EnvKeys.baseUrl);

  /// Enables debug behaviour.
  static bool get isDebug => _getBool(EnvKeys.isDebug);

  /// Enables application logging.
  static bool get enableLogger => _getBool(EnvKeys.enableLogger);

  /// Returns a required configuration value.
  ///
  /// Throws a [StateError] if the key does not exist.
  static String _getValue(String key) {
    _ensureLoaded();

    final value = dotenv.maybeGet(key);

    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing required environment variable: $key',
      );
    }

    return value;
  }

  /// Reads a boolean configuration value.
  ///
  /// Missing values are treated as `false`.
  static bool _getBool(String key) {
    _ensureLoaded();

    return dotenv.maybeGet(key) == 'true';
  }

  /// Ensures that the environment has been loaded before reading values.
  static void _ensureLoaded() {
    if (!dotenv.isInitialized) {
      throw StateError(
        'Environment has not been initialized.',
      );
    }
  }
}