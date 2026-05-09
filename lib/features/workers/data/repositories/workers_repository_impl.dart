import 'package:injectable/injectable.dart';

import '../../domain/entities/worker_details_data.dart';
import '../../domain/entities/worker_list_item.dart';
import '../../domain/repositories/workers_repository.dart';
import '../datasources/workers_local_data_source.dart';

@LazySingleton(as: WorkersRepository)
class WorkersRepositoryImpl implements WorkersRepository {
  WorkersRepositoryImpl(this._dataSource);

  final WorkersLocalDataSource _dataSource;

  @override
  Stream<List<WorkerListItem>> watchWorkers(DateTime month) =>
      _dataSource.watchWorkers(month);

  @override
  Stream<WorkerDetailsData> watchWorkerDetails(int workerId, DateTime month) =>
      _dataSource.watchWorkerDetails(workerId, month);

  @override
  Future<void> addWorker(String name) => _dataSource.addWorker(name);

  @override
  Future<void> deleteWorker(int workerId) =>
      _dataSource.deleteWorker(workerId);

  @override
  Future<void> addOrUpdateProduction({
    int? productionId, required int workerId,
    required DateTime date, required int stitchCount, String? notes,
  }) => _dataSource.addOrUpdateProduction(
    productionId: productionId, workerId: workerId,
    date: date, stitchCount: stitchCount, notes: notes,
  );

  @override
  Future<void> deleteProduction(int productionId) =>
      _dataSource.deleteProduction(productionId);

  @override
  Future<void> addAdvance({
    required int workerId, required double amount,
    required DateTime date, String? notes,
  }) => _dataSource.addAdvance(
    workerId: workerId, amount: amount, date: date, notes: notes,
  );

  @override
  Future<void> addOrUpdateAdvance({
    int? advanceId, required int workerId, required double amount,
    required DateTime date, String? notes,
  }) => _dataSource.addOrUpdateAdvance(
    advanceId: advanceId, workerId: workerId,
    amount: amount, date: date, notes: notes,
  );

  @override
  Future<void> deleteAdvance(int advanceId) =>
      _dataSource.deleteAdvance(advanceId);

  @override
  Future<void> addDeduction({
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _localDataSource.addDeduction(
      workerId: workerId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }

  @override
  Future<void> deleteDeduction(int deductionId) {
    return _localDataSource.deleteDeduction(deductionId);
  }

  @override
  Future<void> upsertAbsentDays({
    required int workerId, required DateTime month,
    required int absentDays,
  }) => _dataSource.upsertAbsentDays(
    workerId: workerId, month: month, absentDays: absentDays,
  );

  @override
  Future<void> updateStitchRate({
    required double rate, required DateTime effectiveFrom,
  }) => _dataSource.updateStitchRate(rate: rate, effectiveFrom: effectiveFrom);
}
