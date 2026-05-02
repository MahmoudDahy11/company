// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:company/core/database/app_database.dart' as _i549;
import 'package:company/core/di/register_module.dart' as _i673;
import 'package:company/core/firebase/firebase_initializer.dart' as _i221;
import 'package:company/core/localization/app_locale_controller.dart' as _i707;
import 'package:company/core/router/app_router.dart' as _i512;
import 'package:company/core/sync/connectivity_service.dart' as _i447;
import 'package:company/core/sync/sync_remote_data_source.dart' as _i671;
import 'package:company/core/sync/sync_service.dart' as _i807;
import 'package:company/core/sync/sync_status_cubit.dart' as _i359;
import 'package:company/features/threads/data/datasources/threads_local_data_source.dart'
    as _i906;
import 'package:company/features/threads/data/repositories/threads_repository_impl.dart'
    as _i424;
import 'package:company/features/threads/domain/repositories/threads_repository.dart'
    as _i552;
import 'package:company/features/threads/domain/usecases/add_purchase_usecase.dart'
    as _i212;
import 'package:company/features/threads/domain/usecases/add_supplier_payment_usecase.dart'
    as _i896;
import 'package:company/features/threads/domain/usecases/add_supplier_usecase.dart'
    as _i850;
import 'package:company/features/threads/domain/usecases/delete_purchase_usecase.dart'
    as _i1059;
import 'package:company/features/threads/domain/usecases/delete_supplier_payment_usecase.dart'
    as _i970;
import 'package:company/features/threads/domain/usecases/delete_supplier_usecase.dart'
    as _i834;
import 'package:company/features/threads/domain/usecases/watch_supplier_details_usecase.dart'
    as _i233;
import 'package:company/features/threads/domain/usecases/watch_suppliers_usecase.dart'
    as _i63;
import 'package:company/features/threads/domain/usecases/watch_threads_overview_usecase.dart'
    as _i824;
import 'package:company/features/threads/presentation/bloc/supplier_details_cubit.dart'
    as _i850;
import 'package:company/features/threads/presentation/bloc/threads_cubit.dart'
    as _i136;
import 'package:company/features/women_staff/data/datasources/women_staff_local_data_source.dart'
    as _i387;
import 'package:company/features/women_staff/data/repositories/women_staff_repository_impl.dart'
    as _i74;
import 'package:company/features/women_staff/domain/repositories/women_staff_repository.dart'
    as _i640;
import 'package:company/features/women_staff/domain/usecases/add_staff_advance_usecase.dart'
    as _i478;
import 'package:company/features/women_staff/domain/usecases/add_staff_usecase.dart'
    as _i361;
import 'package:company/features/women_staff/domain/usecases/delete_staff_advance_usecase.dart'
    as _i732;
import 'package:company/features/women_staff/domain/usecases/delete_staff_usecase.dart'
    as _i166;
import 'package:company/features/women_staff/domain/usecases/update_salary_usecase.dart'
    as _i282;
import 'package:company/features/women_staff/domain/usecases/watch_staff_details_usecase.dart'
    as _i81;
import 'package:company/features/women_staff/domain/usecases/watch_staff_usecase.dart'
    as _i829;
import 'package:company/features/women_staff/presentation/bloc/staff_details_cubit.dart'
    as _i922;
import 'package:company/features/women_staff/presentation/bloc/women_staff_cubit.dart'
    as _i411;
import 'package:company/features/workers/data/datasources/workers_local_data_source.dart'
    as _i493;
import 'package:company/features/workers/data/repositories/workers_repository_impl.dart'
    as _i741;
import 'package:company/features/workers/domain/repositories/workers_repository.dart'
    as _i1023;
import 'package:company/features/workers/domain/usecases/add_advance_usecase.dart'
    as _i454;
import 'package:company/features/workers/domain/usecases/add_or_update_production_usecase.dart'
    as _i663;
import 'package:company/features/workers/domain/usecases/add_worker_usecase.dart'
    as _i537;
import 'package:company/features/workers/domain/usecases/delete_advance_usecase.dart'
    as _i1064;
import 'package:company/features/workers/domain/usecases/delete_production_usecase.dart'
    as _i970;
import 'package:company/features/workers/domain/usecases/delete_worker_usecase.dart'
    as _i526;
import 'package:company/features/workers/domain/usecases/update_stitch_rate_usecase.dart'
    as _i134;
import 'package:company/features/workers/domain/usecases/upsert_absent_days_usecase.dart'
    as _i704;
import 'package:company/features/workers/domain/usecases/watch_worker_details_usecase.dart'
    as _i455;
import 'package:company/features/workers/domain/usecases/watch_workers_usecase.dart'
    as _i511;
import 'package:company/features/workers/presentation/bloc/worker_details_cubit.dart'
    as _i105;
import 'package:company/features/workers/presentation/bloc/workers_cubit.dart'
    as _i109;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
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
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => registerModule.firebaseFirestore,
    );
    gh.lazySingleton<_i359.SyncStatusCubit>(
      () => _i359.SyncStatusCubit(gh<_i549.AppDatabase>()),
    );
    gh.lazySingleton<_i906.ThreadsLocalDataSource>(
      () => _i906.ThreadsLocalDataSource(gh<_i549.AppDatabase>()),
    );
    gh.lazySingleton<_i387.WomenStaffLocalDataSource>(
      () => _i387.WomenStaffLocalDataSource(gh<_i549.AppDatabase>()),
    );
    gh.lazySingleton<_i493.WorkersLocalDataSource>(
      () => _i493.WorkersLocalDataSource(gh<_i549.AppDatabase>()),
    );
    gh.lazySingleton<_i447.ConnectivityService>(
      () => _i447.ConnectivityService(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i640.WomenStaffRepository>(
      () =>
          _i74.WomenStaffRepositoryImpl(gh<_i387.WomenStaffLocalDataSource>()),
    );
    gh.lazySingleton<_i671.SyncRemoteDataSource>(
      () => _i671.SyncRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i1023.WorkersRepository>(
      () => _i741.WorkersRepositoryImpl(gh<_i493.WorkersLocalDataSource>()),
    );
    gh.lazySingleton<_i552.ThreadsRepository>(
      () => _i424.ThreadsRepositoryImpl(gh<_i906.ThreadsLocalDataSource>()),
    );
    gh.factory<_i454.AddAdvanceUseCase>(
      () => _i454.AddAdvanceUseCase(gh<_i1023.WorkersRepository>()),
    );
    gh.factory<_i663.AddOrUpdateProductionUseCase>(
      () => _i663.AddOrUpdateProductionUseCase(gh<_i1023.WorkersRepository>()),
    );
    gh.factory<_i537.AddWorkerUseCase>(
      () => _i537.AddWorkerUseCase(gh<_i1023.WorkersRepository>()),
    );
    gh.factory<_i1064.DeleteAdvanceUseCase>(
      () => _i1064.DeleteAdvanceUseCase(gh<_i1023.WorkersRepository>()),
    );
    gh.factory<_i970.DeleteProductionUseCase>(
      () => _i970.DeleteProductionUseCase(gh<_i1023.WorkersRepository>()),
    );
    gh.factory<_i526.DeleteWorkerUseCase>(
      () => _i526.DeleteWorkerUseCase(gh<_i1023.WorkersRepository>()),
    );
    gh.factory<_i134.UpdateStitchRateUseCase>(
      () => _i134.UpdateStitchRateUseCase(gh<_i1023.WorkersRepository>()),
    );
    gh.factory<_i704.UpsertAbsentDaysUseCase>(
      () => _i704.UpsertAbsentDaysUseCase(gh<_i1023.WorkersRepository>()),
    );
    gh.factory<_i455.WatchWorkerDetailsUseCase>(
      () => _i455.WatchWorkerDetailsUseCase(gh<_i1023.WorkersRepository>()),
    );
    gh.factory<_i511.WatchWorkersUseCase>(
      () => _i511.WatchWorkersUseCase(gh<_i1023.WorkersRepository>()),
    );
    gh.factory<_i109.WorkersCubit>(
      () => _i109.WorkersCubit(
        gh<_i511.WatchWorkersUseCase>(),
        gh<_i537.AddWorkerUseCase>(),
        gh<_i526.DeleteWorkerUseCase>(),
        gh<_i134.UpdateStitchRateUseCase>(),
      ),
    );
    gh.factory<_i105.WorkerDetailsCubit>(
      () => _i105.WorkerDetailsCubit(
        gh<_i455.WatchWorkerDetailsUseCase>(),
        gh<_i663.AddOrUpdateProductionUseCase>(),
        gh<_i970.DeleteProductionUseCase>(),
        gh<_i454.AddAdvanceUseCase>(),
        gh<_i1064.DeleteAdvanceUseCase>(),
        gh<_i704.UpsertAbsentDaysUseCase>(),
      ),
    );
    gh.lazySingleton<_i807.SyncService>(
      () => _i807.SyncService(
        gh<_i549.AppDatabase>(),
        gh<_i447.ConnectivityService>(),
        gh<_i671.SyncRemoteDataSource>(),
        gh<_i359.SyncStatusCubit>(),
      ),
    );
    gh.factory<_i212.AddPurchaseUseCase>(
      () => _i212.AddPurchaseUseCase(gh<_i552.ThreadsRepository>()),
    );
    gh.factory<_i896.AddSupplierPaymentUseCase>(
      () => _i896.AddSupplierPaymentUseCase(gh<_i552.ThreadsRepository>()),
    );
    gh.factory<_i850.AddSupplierUseCase>(
      () => _i850.AddSupplierUseCase(gh<_i552.ThreadsRepository>()),
    );
    gh.factory<_i1059.DeletePurchaseUseCase>(
      () => _i1059.DeletePurchaseUseCase(gh<_i552.ThreadsRepository>()),
    );
    gh.factory<_i970.DeleteSupplierPaymentUseCase>(
      () => _i970.DeleteSupplierPaymentUseCase(gh<_i552.ThreadsRepository>()),
    );
    gh.factory<_i834.DeleteSupplierUseCase>(
      () => _i834.DeleteSupplierUseCase(gh<_i552.ThreadsRepository>()),
    );
    gh.factory<_i233.WatchSupplierDetailsUseCase>(
      () => _i233.WatchSupplierDetailsUseCase(gh<_i552.ThreadsRepository>()),
    );
    gh.factory<_i63.WatchSuppliersUseCase>(
      () => _i63.WatchSuppliersUseCase(gh<_i552.ThreadsRepository>()),
    );
    gh.factory<_i824.WatchThreadsOverviewUseCase>(
      () => _i824.WatchThreadsOverviewUseCase(gh<_i552.ThreadsRepository>()),
    );
    gh.factory<_i478.AddStaffAdvanceUseCase>(
      () => _i478.AddStaffAdvanceUseCase(gh<_i640.WomenStaffRepository>()),
    );
    gh.factory<_i361.AddStaffUseCase>(
      () => _i361.AddStaffUseCase(gh<_i640.WomenStaffRepository>()),
    );
    gh.factory<_i732.DeleteStaffAdvanceUseCase>(
      () => _i732.DeleteStaffAdvanceUseCase(gh<_i640.WomenStaffRepository>()),
    );
    gh.factory<_i166.DeleteStaffUseCase>(
      () => _i166.DeleteStaffUseCase(gh<_i640.WomenStaffRepository>()),
    );
    gh.factory<_i282.UpdateSalaryUseCase>(
      () => _i282.UpdateSalaryUseCase(gh<_i640.WomenStaffRepository>()),
    );
    gh.factory<_i81.WatchStaffDetailsUseCase>(
      () => _i81.WatchStaffDetailsUseCase(gh<_i640.WomenStaffRepository>()),
    );
    gh.factory<_i829.WatchStaffUseCase>(
      () => _i829.WatchStaffUseCase(gh<_i640.WomenStaffRepository>()),
    );
    gh.factory<_i850.SupplierDetailsCubit>(
      () => _i850.SupplierDetailsCubit(
        gh<_i233.WatchSupplierDetailsUseCase>(),
        gh<_i212.AddPurchaseUseCase>(),
        gh<_i1059.DeletePurchaseUseCase>(),
        gh<_i896.AddSupplierPaymentUseCase>(),
        gh<_i970.DeleteSupplierPaymentUseCase>(),
      ),
    );
    gh.factory<_i411.WomenStaffCubit>(
      () => _i411.WomenStaffCubit(
        gh<_i829.WatchStaffUseCase>(),
        gh<_i361.AddStaffUseCase>(),
        gh<_i166.DeleteStaffUseCase>(),
      ),
    );
    gh.factory<_i922.StaffDetailsCubit>(
      () => _i922.StaffDetailsCubit(
        gh<_i81.WatchStaffDetailsUseCase>(),
        gh<_i478.AddStaffAdvanceUseCase>(),
        gh<_i732.DeleteStaffAdvanceUseCase>(),
        gh<_i282.UpdateSalaryUseCase>(),
      ),
    );
    gh.factory<_i136.ThreadsCubit>(
      () => _i136.ThreadsCubit(
        gh<_i63.WatchSuppliersUseCase>(),
        gh<_i824.WatchThreadsOverviewUseCase>(),
        gh<_i850.AddSupplierUseCase>(),
        gh<_i834.DeleteSupplierUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i673.RegisterModule {}
