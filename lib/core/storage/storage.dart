import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides access to regular and secure application storage.
final class Storage {
  Storage() : _secureStorage = const FlutterSecureStorage();

  SharedPreferencesAsync? _preferences;
  final FlutterSecureStorage _secureStorage;

  /// Writes a supported value to regular application storage.
  Future<void> write(String key, Object value) async {
    switch (value) {
      case bool value:
        await _preferencesInstance.setBool(key, value);
      case int value:
        await _preferencesInstance.setInt(key, value);
      case double value:
        await _preferencesInstance.setDouble(key, value);
      case String value:
        await _preferencesInstance.setString(key, value);
      case List<String> value:
        await _preferencesInstance.setStringList(key, value);
      default:
        throw ArgumentError.value(
          value,
          'value',
          'Only bool, int, double, String, and List<String> values are supported.',
        );
    }
  }

  /// Reads a typed value from regular application storage.
  Future<T?> read<T>(String key) async {
    if (T == bool) {
      return await _preferencesInstance.getBool(key) as T?;
    }
    if (T == int) {
      return await _preferencesInstance.getInt(key) as T?;
    }
    if (T == double) {
      return await _preferencesInstance.getDouble(key) as T?;
    }
    if (T == String) {
      return await _preferencesInstance.getString(key) as T?;
    }
    if (T == List<String>) {
      return await _preferencesInstance.getStringList(key) as T?;
    }

    throw ArgumentError.value(
      T,
      'T',
      'Only bool, int, double, String, and List<String> types are supported.',
    );
  }

  /// Deletes a value from regular application storage.
  Future<void> delete(String key) {
    return _preferencesInstance.remove(key);
  }

  /// Deletes all values from regular application storage.
  Future<void> clear() {
    return _preferencesInstance.clear();
  }

  /// Writes a sensitive string to secure application storage.
  Future<void> writeSecure(String key, String value) {
    return _secureStorage.write(key: key, value: value);
  }

  /// Reads a sensitive string from secure application storage.
  Future<String?> readSecure(String key) {
    return _secureStorage.read(key: key);
  }

  /// Deletes a sensitive value from secure application storage.
  Future<void> deleteSecure(String key) {
    return _secureStorage.delete(key: key);
  }

  /// Deletes all sensitive values from secure application storage.
  Future<void> clearSecure() {
    return _secureStorage.deleteAll();
  }

  SharedPreferencesAsync get _preferencesInstance {
    return _preferences ??= SharedPreferencesAsync();
  }
}
