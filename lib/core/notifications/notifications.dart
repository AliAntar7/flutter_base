import 'package:firebase_messaging/firebase_messaging.dart'
    as firebase_messaging;

/// Provides Firebase Cloud Messaging access for the application.
final class Notifications {
  firebase_messaging.FirebaseMessaging? _messaging;
  bool _wasInitialized = false;

  /// Initializes Firebase Cloud Messaging once during application startup.
  Future<void> initialize() async {
    if (_wasInitialized) {
      throw StateError('Notifications have already been initialized.');
    }

    final messaging = firebase_messaging.FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    _messaging = messaging;
    _wasInitialized = true;
  }

  /// Returns the current Firebase Cloud Messaging token.
  Future<String?> getToken() {
    return _requireMessaging().getToken();
  }

  /// Emits a new token whenever Firebase Cloud Messaging refreshes it.
  Stream<String> get onTokenRefresh {
    return _requireMessaging().onTokenRefresh;
  }

  firebase_messaging.FirebaseMessaging _requireMessaging() {
    if (!_wasInitialized) {
      throw StateError('Notifications must be initialized first.');
    }

    return _messaging!;
  }
}
