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
import '../core/storage/storage_service.dart';

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
  // TODO(Ali): Re-enable Firebase after adding the platform configuration
  // files, such as ios/Runner/GoogleService-Info.plist.
  // await firebase.initialize();

  // 5. Initialize notifications.
  final notifications = Notifications();
  // Notifications depend on Firebase Messaging, so keep them disabled until
  // Firebase has been configured.
  // TODO(Ali): Re-enable notifications after Firebase initialization.
  // await notifications.initialize();

  // 6. Initialize local storage.
  final storage = StorageService();

  // 7. Configure logging.
  AppLogger.initialize(
    enableLogging: AppConfig.enableLogger,
  );

  // 8. Initialize networking.
  final network = Network(storage: storage);

  // 9. Register dependency injection.
  DependencyInjection.initialize(
    storage: storage,
    network: network,
    firebase: firebase,
    notifications: notifications,
  );

  // 10. Build and run the application.
  runApp(await builder());
}
