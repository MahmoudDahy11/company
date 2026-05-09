import 'dart:async';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/worker_details_data.dart';
import '../../domain/entities/worker_list_item.dart';
import '../helpers/worker_sync_helper.dart';
import '../query_builders/worker_details_builder.dart';
import '../query_builders/worker_list_builder.dart';
import 'worker_advance_data_source.dart';
import 'worker_production_data_source.dart';
import 'worker_rate_data_source.dart';

@lazySingleton
class WorkersLocalDataSource {
  WorkersLocalDataSource(
    this._database,
    this._listBuilder,
    this._detailsBuilder,
    this._productionDataSource,
    this._advanceDataSource,
    this._rateDataSource,
  );

  final AppDatabase _database;
  final WorkerListBuilder _listBuilder;
  final WorkerDetailsBuilder _detailsBuilder;
  final WorkerProductionDataSource _productionDataSource;
  final WorkerAdvanceDataSource _advanceDataSource;
  final WorkerRateDataSource _rateDataSource;

  Stream<List<WorkerListItem>> watchWorkers(DateTime month) => _listBuilder
      .watchWorkersTrigger()
      .asyncMap((_) => _listBuilder.buildWorkerList(month));

  Stream<WorkerDetailsData> watchWorkerDetails(int workerId, DateTime month) =>
      _listBuilder.watchWorkersTrigger().asyncMap(
        (_) => _detailsBuilder.buildWorkerDetails(workerId, month),
      );

  Future<void> addWorker(String name) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.workers)
          .insert(WorkersCompanion.insert(name: name.trim()));
      final row = await (_database.select(
        _database.workers,
      )..where((t) => t.id.equals(id))).getSingle();
      await queueSync(
        _database,
        operation: SyncQueueOperation.insert,
        tableName: 'workers',
        recordId: id,
        payload: row.toJson(),
      );
    });
  }

  Future<void> deleteWorker(int workerId) async {
    final existing = await (_database.select(
      _database.workers,
    )..where((table) => table.id.equals(workerId))).getSingleOrNull();
    if (existing == null) return;
    await _database.transaction(() async {
      await (_database.update(_database.workers)
            ..where((table) => table.id.equals(workerId)))
          .write(const WorkersCompanion(isActive: Value(false)));
      final row = await (_database.select(
        _database.workers,
      )..where((t) => t.id.equals(workerId))).getSingle();
      await queueSync(
        _database,
        operation: SyncQueueOperation.update,
        tableName: 'workers',
        recordId: workerId,
        payload: row.toJson(),
      );
    });
  }

  Future<void> addOrUpdateProduction({
    int? productionId,
    required int workerId,
    required DateTime date,
    required int stitchCount,
    String? notes,
  }) => _productionDataSource.addOrUpdateProduction(
    productionId: productionId,
    workerId: workerId,
    date: date,
    stitchCount: stitchCount,
    notes: notes,
  );

  Future<void> deleteProduction(int productionId) =>
      _productionDataSource.deleteProduction(productionId);

  Future<void> addAdvance({
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) => _advanceDataSource.addAdvance(
    workerId: workerId,
    amount: amount,
    date: date,
    notes: notes,
  );

  Future<void> addOrUpdateAdvance({
    int? advanceId,
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) => _advanceDataSource.addOrUpdateAdvance(
    advanceId: advanceId,
    workerId: workerId,
    amount: amount,
    date: date,
    notes: notes,
  );

  Future<void> deleteAdvance(int advanceId) =>
      _advanceDataSource.deleteAdvance(advanceId);

  Future<void> upsertAbsentDays({
    required int workerId,
    required DateTime month,
    required int absentDays,
  }) => _advanceDataSource.upsertAbsentDays(
    workerId: workerId,
    month: month,
    absentDays: absentDays,
  );

  Future<void> updateStitchRate({
    required double rate,
    required DateTime effectiveFrom,
  }) => _rateDataSource.updateStitchRate(
    rate: rate,
    effectiveFrom: effectiveFrom,
  );

  Future<void> addDeduction({
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      await _database
          .into(_database.workerDeductions)
          .insert(
            WorkerDeductionsCompanion.insert(
              workerId: workerId,
              amount: amount,
              date: date,
              notes: Value(notes),
            ),
          );
      await queueSync(
        _database,
        operation: SyncQueueOperation.insert,
        tableName: 'worker_deductions',
        recordId: -1,
        payload: <String, dynamic>{
          'workerId': workerId,
          'amount': amount,
          'date': date.toIso8601String(),
          'notes': notes,
        },
      );
    });
  }

  Future<void> deleteDeduction(int deductionId) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.workerDeductions,
      )..where((t) => t.id.equals(deductionId))).go();
      await queueSync(
        _database,
        operation: SyncQueueOperation.delete,
        tableName: 'worker_deductions',
        recordId: deductionId,
        payload: <String, dynamic>{'id': deductionId},
      );
    });
  }
}
