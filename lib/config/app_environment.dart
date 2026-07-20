import 'app_flavor.dart';

/// Stores the application flavor selected during startup.
abstract final class AppEnvironment {
  static AppFlavor _current = AppFlavor.development;
  static bool _wasConfigured = false;

  /// The current application flavor.
  static AppFlavor get current => _current;

  /// Initializes the application flavor once during application startup.
  ///
  /// Calling this method more than once is an application configuration error.
  static void initialize(AppFlavor flavor) {
    if (_wasConfigured) {
      throw StateError('The application flavor has already been configured.');
    }

    _current = flavor;
    _wasConfigured = true;
  }
}
