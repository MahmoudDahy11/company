import 'package:injectable/injectable.dart';

import '../../domain/entities/worker_details_data.dart';
import '../../domain/entities/worker_list_item.dart';
import '../../domain/repositories/workers_repository.dart';
import '../datasources/workers_local_data_source.dart';

@LazySingleton(as: WorkersRepository)
class WorkersRepositoryImpl implements WorkersRepository {
  WorkersRepositoryImpl(this._localDataSource);

  final WorkersLocalDataSource _localDataSource;

  @override
  Stream<List<WorkerListItem>> watchWorkers(DateTime month) {
    return _localDataSource.watchWorkers(month);
  }

  @override
  Stream<WorkerDetailsData> watchWorkerDetails(int workerId, DateTime month) {
    return _localDataSource.watchWorkerDetails(workerId, month);
  }

  @override
  Future<void> addWorker(String name) {
    return _localDataSource.addWorker(name);
  }

  @override
  Future<void> deleteWorker(int workerId) {
    return _localDataSource.deleteWorker(workerId);
  }

  @override
  Future<void> addOrUpdateProduction({
    int? productionId,
    required int workerId,
    required DateTime date,
    required int stitchCount,
    String? notes,
  }) {
    return _localDataSource.addOrUpdateProduction(
      productionId: productionId,
      workerId: workerId,
      date: date,
      stitchCount: stitchCount,
      notes: notes,
    );
  }

  @override
  Future<void> deleteProduction(int productionId) {
    return _localDataSource.deleteProduction(productionId);
  }

  @override
  Future<void> addAdvance({
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _localDataSource.addAdvance(
      workerId: workerId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }

  @override
  Future<void> deleteAdvance(int advanceId) {
    return _localDataSource.deleteAdvance(advanceId);
  }

  @override
  Future<void> upsertAbsentDays({
    required int workerId,
    required DateTime month,
    required int absentDays,
  }) {
    return _localDataSource.upsertAbsentDays(
      workerId: workerId,
      month: month,
      absentDays: absentDays,
    );
  }

  @override
  Future<void> updateStitchRate({
    required double rate,
    required DateTime effectiveFrom,
  }) {
    return _localDataSource.updateStitchRate(
      rate: rate,
      effectiveFrom: effectiveFrom,
    );
  }
}
