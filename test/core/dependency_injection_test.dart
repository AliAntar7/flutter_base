import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_base/core/di/di.dart';
import 'package:flutter_base/core/firebase/firebase.dart';
import 'package:flutter_base/core/logger/logger.dart';
import 'package:flutter_base/core/network/network.dart';
import 'package:flutter_base/core/notifications/notifications.dart';
import 'package:flutter_base/core/storage/storage.dart';

void main() {
  test('registers core instances and resolves them by type', () {
    final logger = AppLogger(enabled: false);
    final storage = Storage();
    final network = Network(
      baseUrl: 'https://example.com',
      storage: storage,
      logger: logger,
    );
    final firebase = AppFirebase();
    final notifications = Notifications();

    DependencyInjection.initialize(
      logger: logger,
      storage: storage,
      network: network,
      firebase: firebase,
      notifications: notifications,
    );

    expect(DependencyInjection.get<AppLogger>(), same(logger));
    expect(DependencyInjection.get<Storage>(), same(storage));
    expect(DependencyInjection.get<Network>(), same(network));
    expect(DependencyInjection.get<AppFirebase>(), same(firebase));
    expect(DependencyInjection.get<Notifications>(), same(notifications));
  });
}
