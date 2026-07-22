import 'package:flutter_base/core/storage/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Provides access to the application's local storage.
///
/// Regular values are stored using SharedPreferences.
/// Sensitive values are stored using FlutterSecureStorage.
///
/// Features should never interact with these packages directly.
final class StorageService {
  StorageService()
      : _preferences = SharedPreferencesAsync(),
        _secureStorage = const FlutterSecureStorage();

  final SharedPreferencesAsync _preferences;
  final FlutterSecureStorage _secureStorage;

  // ---------------------------------------------------------------------------
  // Regular Storage
  // ---------------------------------------------------------------------------

  Future<void> writeString(
      StorageKeys key,
      String value,
      ) {
    return _preferences.setString(
      key.key,
      value,
    );
  }

  Future<String?> readString(
      StorageKeys key,
      ) {
    return _preferences.getString(
      key.key,
    );
  }

  Future<void> writeBool(
      StorageKeys key,
      bool value,
      ) {
    return _preferences.setBool(
      key.key,
      value,
    );
  }

  Future<bool?> readBool(
      StorageKeys key,
      ) {
    return _preferences.getBool(
      key.key,
    );
  }

  Future<void> writeInt(
      StorageKeys key,
      int value,
      ) {
    return _preferences.setInt(
      key.key,
      value,
    );
  }

  Future<int?> readInt(
      StorageKeys key,
      ) {
    return _preferences.getInt(
      key.key,
    );
  }

  Future<void> writeDouble(
      StorageKeys key,
      double value,
      ) {
    return _preferences.setDouble(
      key.key,
      value,
    );
  }

  Future<double?> readDouble(
      StorageKeys key,
      ) {
    return _preferences.getDouble(
      key.key,
    );
  }

  Future<void> writeStringList(
      StorageKeys key,
      List<String> value,
      ) {
    return _preferences.setStringList(
      key.key,
      value,
    );
  }

  Future<List<String>?> readStringList(
      StorageKeys key,
      ) {
    return _preferences.getStringList(
      key.key,
    );
  }

  Future<void> delete(
      StorageKeys key,
      ) {
    return _preferences.remove(
      key.key,
    );
  }

  Future<void> clear() {
    return _preferences.clear();
  }

  // ---------------------------------------------------------------------------
  // Secure Storage
  // ---------------------------------------------------------------------------

  Future<void> writeSecure(
      StorageKeys key,
      String value,
      ) {
    return _secureStorage.write(
      key: key.key,
      value: value,
    );
  }

  Future<String?> readSecure(
      StorageKeys key,
      ) {
    return _secureStorage.read(
      key: key.key,
    );
  }

  Future<void> deleteSecure(
      StorageKeys key,
      ) {
    return _secureStorage.delete(
      key: key.key,
    );
  }

  Future<void> clearSecure() {
    return _secureStorage.deleteAll();
  }

  /// Clears both regular and secure storage.
  Future<void> clearAll() async {
    await clear();
    await clearSecure();
  }
}