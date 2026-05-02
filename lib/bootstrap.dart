import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/firebase/firebase_initializer.dart';

Future<void> bootstrap() async {
  await configureDependencies();
  await GetIt.I<FirebaseInitializer>().initialize();
  runApp(const FactoryApp());
}
