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
  await GetIt.I<SyncService>().start();
  runApp(const FactoryApp());
}
