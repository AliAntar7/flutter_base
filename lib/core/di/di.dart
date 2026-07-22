import 'package:get_it/get_it.dart';

import '../firebase/firebase.dart';
import '../logger/logger.dart';
import '../network/network.dart';
import '../notifications/notifications.dart';
import '../storage/storage_service.dart';

/// Registers and resolves application dependencies.
abstract final class DependencyInjection {
  static final GetIt _locator = GetIt.asNewInstance();
  static bool _wasInitialized = false;

  /// Registers the initialized core modules once during application startup.
  static void initialize({
    required StorageService storage,
    required Network network,
    required AppFirebase firebase,
    required Notifications notifications,
  }) {
    if (_wasInitialized) {
      throw StateError('Dependency injection has already been initialized.');
    }

    _locator.registerSingleton<StorageService>(storage);
    _locator.registerSingleton<Network>(network);
    _locator.registerSingleton<AppFirebase>(firebase);
    _locator.registerSingleton<Notifications>(notifications);
    _wasInitialized = true;
  }

  /// Resolves a registered dependency by type.
  static T get<T extends Object>() {
    return _locator<T>();
  }
}
