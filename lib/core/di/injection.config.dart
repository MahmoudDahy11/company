// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:company/core/database/app_database.dart' as _i549;
import 'package:company/core/di/register_module.dart' as _i673;
import 'package:company/core/firebase/firebase_initializer.dart' as _i221;
import 'package:company/core/localization/app_locale_controller.dart' as _i707;
import 'package:company/core/router/app_router.dart' as _i512;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i707.AppLocaleController>(
      () => registerModule.localeController,
    );
    gh.lazySingleton<_i549.AppDatabase>(() => registerModule.appDatabase);
    gh.lazySingleton<_i221.FirebaseInitializer>(
      () => registerModule.firebaseInitializer,
    );
    gh.lazySingleton<_i512.AppRouter>(() => registerModule.appRouter);
    return this;
  }
}

class _$RegisterModule extends _i673.RegisterModule {}
