import 'package:injectable/injectable.dart';

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
}
