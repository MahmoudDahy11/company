import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../firebase/firebase_initializer.dart';
import '../localization/app_locale_controller.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  AppLocaleController get localeController => AppLocaleController();

  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  FirebaseInitializer get firebaseInitializer => FirebaseInitializer();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
