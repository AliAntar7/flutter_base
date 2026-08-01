import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_base/core/di/di.dart';
import 'package:flutter_base/core/firebase/firebase.dart';
import 'package:flutter_base/core/notifications/notifications.dart';
import 'package:flutter_base/core/storage/storage_service.dart';

void main() {
  test('registers core instances and resolves them by type', () {
    final storage = StorageService();
    final firebase = AppFirebase();
    final notifications = Notifications();

    DependencyInjection.initialize(
      storage: storage,
      firebase: firebase,
      notifications: notifications,
    );

    expect(DependencyInjection.get<StorageService>(), same(storage));
    expect(DependencyInjection.get<AppFirebase>(), same(firebase));
    expect(DependencyInjection.get<Notifications>(), same(notifications));
  });
}
