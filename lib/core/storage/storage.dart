import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides access to regular and secure application storage.
abstract final class Storage {
  static SharedPreferencesAsync? _preferences;
  static FlutterSecureStorage? _secureStorage;
  static bool _wasInitialized = false;

  /// Initializes storage once during application startup.
  static Future<void> initialize() async {
    if (_wasInitialized) {
      throw StateError('Application storage has already been initialized.');
    }

    _preferences = SharedPreferencesAsync();
    _secureStorage = const FlutterSecureStorage();
    _wasInitialized = true;
  }

  /// Writes a supported value to regular application storage.
  static Future<void> write(String key, Object value) async {
    final preferences = _requirePreferences();

    switch (value) {
      case bool value:
        await preferences.setBool(key, value);
      case int value:
        await preferences.setInt(key, value);
      case double value:
        await preferences.setDouble(key, value);
      case String value:
        await preferences.setString(key, value);
      case List<String> value:
        await preferences.setStringList(key, value);
      default:
        throw ArgumentError.value(
          value,
          'value',
          'Only bool, int, double, String, and List<String> values are supported.',
        );
    }
  }

  /// Reads a typed value from regular application storage.
  static Future<T?> read<T>(String key) async {
    final preferences = _requirePreferences();

    if (T == bool) {
      return await preferences.getBool(key) as T?;
    }
    if (T == int) {
      return await preferences.getInt(key) as T?;
    }
    if (T == double) {
      return await preferences.getDouble(key) as T?;
    }
    if (T == String) {
      return await preferences.getString(key) as T?;
    }
    if (T == List<String>) {
      return await preferences.getStringList(key) as T?;
    }

    throw ArgumentError.value(
      T,
      'T',
      'Only bool, int, double, String, and List<String> types are supported.',
    );
  }

  /// Deletes a value from regular application storage.
  static Future<void> delete(String key) {
    return _requirePreferences().remove(key);
  }

  /// Deletes all values from regular application storage.
  static Future<void> clear() {
    return _requirePreferences().clear();
  }

  /// Writes a sensitive string to secure application storage.
  static Future<void> writeSecure(String key, String value) {
    return _requireSecureStorage().write(key: key, value: value);
  }

  /// Reads a sensitive string from secure application storage.
  static Future<String?> readSecure(String key) {
    return _requireSecureStorage().read(key: key);
  }

  /// Deletes a sensitive value from secure application storage.
  static Future<void> deleteSecure(String key) {
    return _requireSecureStorage().delete(key: key);
  }

  /// Deletes all sensitive values from secure application storage.
  static Future<void> clearSecure() {
    return _requireSecureStorage().deleteAll();
  }

  static SharedPreferencesAsync _requirePreferences() {
    if (!_wasInitialized) {
      throw StateError('Application storage must be initialized first.');
    }

    return _preferences!;
  }

  static FlutterSecureStorage _requireSecureStorage() {
    if (!_wasInitialized) {
      throw StateError('Application storage must be initialized first.');
    }

    return _secureStorage!;
  }
}
