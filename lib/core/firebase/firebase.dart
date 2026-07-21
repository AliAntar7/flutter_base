import 'package:firebase_core/firebase_core.dart' as firebase_core;

/// Provides Firebase Core initialization for the application.
final class AppFirebase {
  bool _wasInitialized = false;

  /// Initializes Firebase once during application startup.
  Future<void> initialize() async {
    if (_wasInitialized) {
      throw StateError('Firebase has already been initialized.');
    }

    if (firebase_core.Firebase.apps.isEmpty) {
      await firebase_core.Firebase.initializeApp();
    }

    _wasInitialized = true;
  }
}
