import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_base/core/router/router.dart';

void main() {
  testWidgets('navigates through the AppRouter API', (tester) async {
    final router = AppRouter(
      routes: [
        GoRoute(path: AppRoutes.home, builder: (_, _) => const Text('Home')),
        GoRoute(path: '/details', builder: (_, _) => const Text('Details')),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router.routerConfig),
    );
    expect(find.text('Home'), findsOneWidget);

    router.go('/details');
    await tester.pumpAndSettle();

    expect(find.text('Details'), findsOneWidget);
  });
}
