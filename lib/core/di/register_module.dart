import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../database/app_database.dart';
import '../firebase/firebase_initializer.dart';
import '../localization/app_locale_controller.dart';
import '../router/app_router.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  AppLocaleController get localeController => AppLocaleController();

  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  FirebaseInitializer get firebaseInitializer => FirebaseInitializer();

  @lazySingleton
  AppRouter get appRouter => AppRouter();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;
}
