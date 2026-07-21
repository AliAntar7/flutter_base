import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Centralized route paths used by the application.
abstract final class AppRoutes {
  /// The root application route.
  static const home = '/';
}

/// Provides the application's navigation API.
///
/// Route definitions are supplied by the application composition layer so
/// this core module does not depend on feature screens.
final class AppRouter {
  /// Creates a router from the application's route definitions.
  AppRouter({
    required List<RouteBase> routes,
    String? initialLocation,
    bool debugLogDiagnostics = false,
  }) : _router = GoRouter(
         routes: List<RouteBase>.unmodifiable(routes),
         initialLocation: initialLocation,
         debugLogDiagnostics: debugLogDiagnostics,
       );

  final GoRouter _router;

  /// The configuration passed to [MaterialApp.router].
  RouterConfig<Object> get routerConfig => _router;

  /// Navigates to [location], replacing the current route stack.
  void go(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  /// Pushes [location] onto the current route stack.
  Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    return _router.push<T>(location, extra: extra);
  }

  /// Replaces the current route with [location].
  Future<T?> replace<T extends Object?>(String location, {Object? extra}) {
    return _router.replace<T>(location, extra: extra);
  }

  /// Returns whether the current route stack can be popped.
  bool canPop() => _router.canPop();

  /// Pops the current route and optionally returns [result].
  void pop<T extends Object?>([T? result]) {
    _router.pop<T>(result);
  }

  /// Releases resources owned by the underlying router.
  void dispose() {
    _router.dispose();
  }
}
