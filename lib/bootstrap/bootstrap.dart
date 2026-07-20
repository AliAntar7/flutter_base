import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../config/app_config.dart';
import '../config/app_environment.dart';
import '../config/app_flavor.dart';
import '../core/logger/logger.dart';

/// Prepares the application and runs the root widget.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // 1. Ensure Flutter is ready before any platform or plugin initialization.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load environment variables before configuration is consumed.
  await dotenv.load();

  // 3. Select the application flavor during startup.
  AppEnvironment.initialize(AppFlavor.development);

  // 4. Initialize Firebase.
  // TODO(Ali): Initialize Firebase.

  // 5. Register dependency injection.
  // TODO(Ali): Register dependency injection.

  // 6. Configure logging.
  AppLogger.initialize(enabled: AppConfig.enableLogger);

  // 7. Build and run the application.
  runApp(await builder());
}
