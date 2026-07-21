import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/localization/localization.dart';
import '../core/router/router.dart';
import '../core/theme/theme.dart';

/// The root widget of the application.
final class App extends StatefulWidget {
  /// Creates the application root.
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> {
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter(
      routes: [
        GoRoute(path: AppRoutes.home, builder: (_, _) => const _HomePage()),
      ],
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLocalization.wrap(
      Builder(
        builder: (context) {
          return MaterialApp.router(
            routerConfig: _router.routerConfig,
            locale: AppLocalization.localeOf(context),
            supportedLocales: AppLocalization.supportedLocalesOf(context),
            localizationsDelegates: AppLocalization.delegatesOf(context),
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
          );
        },
      ),
    );
  }
}

final class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

final class _HomePageState extends State<_HomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.translate(context, 'home.title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(AppLocalization.translate(context, 'home.counter_message')),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        tooltip: AppLocalization.translate(context, 'home.increment'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
