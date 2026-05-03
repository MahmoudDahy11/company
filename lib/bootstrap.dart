import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app.dart';
import 'core/auth/auth_controller.dart';
import 'core/di/injection.dart';
import 'core/firebase/firebase_initializer.dart';
import 'core/sync/sync_service.dart';

Future<void> bootstrap() async {
  await configureDependencies();
  await GetIt.I<FirebaseInitializer>().initialize();
  await GetIt.I<AuthController>().initialize();

  // Official Firebase plugins (Firestore) don't support Linux natively yet.
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.linux) {
    await GetIt.I<SyncService>().start();
  } else {
    if (kDebugMode) {
      debugPrint('SyncService not started on Linux (No Firebase support).');
    }
  }

  runApp(const FactoryApp());
}
