import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../config/app_config.dart';
import '../config/app_environment.dart';
import '../config/app_flavor.dart';
import '../core/di/di.dart';
import '../core/firebase/firebase.dart';
import '../core/logger/logger.dart';
import '../core/network/network.dart';
import '../core/notifications/notifications.dart';
import '../core/storage/storage.dart';

/// Prepares the application and runs the root widget.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // 1. Ensure Flutter is ready before any platform or plugin initialization.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load environment variables before configuration is consumed.
  await dotenv.load();

  // 3. Select the application flavor during startup.
  AppEnvironment.initialize(AppFlavor.development);

  // 4. Initialize Firebase.
  final firebase = AppFirebase();
  await firebase.initialize();

  // 5. Initialize notifications.
  final notifications = Notifications();
  await notifications.initialize();

  // 6. Initialize local storage.
  final storage = Storage();

  // 7. Configure logging.
  final logger = AppLogger(enabled: AppConfig.enableLogger);

  // 8. Initialize networking.
  final network = Network(storage: storage, logger: logger);

  // 9. Register dependency injection.
  DependencyInjection.initialize(
    logger: logger,
    storage: storage,
    network: network,
    firebase: firebase,
    notifications: notifications,
  );

  // 10. Build and run the application.
  runApp(await builder());
}
