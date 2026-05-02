import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart' hide Worker, WorkerAdvance;
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/worker.dart';
import '../../domain/entities/worker_advance.dart';
import '../../domain/entities/worker_details_data.dart';
import '../../domain/entities/worker_list_item.dart';
import '../../domain/entities/worker_month_summary.dart';
import '../../domain/entities/worker_production.dart';

@lazySingleton
class WorkersLocalDataSource {
  WorkersLocalDataSource(this._database);

  final AppDatabase _database;

  Stream<List<WorkerListItem>> watchWorkers(DateTime month) {
    return _watchWorkersTrigger().asyncMap((_) => _buildWorkerList(month));
  }

  Stream<WorkerDetailsData> watchWorkerDetails(int workerId, DateTime month) {
    return _watchWorkersTrigger().asyncMap(
      (_) => _buildWorkerDetails(workerId, month),
    );
  }

  Future<void> addWorker(String name) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.workers)
          .insert(WorkersCompanion.insert(name: name.trim()));

      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'workers',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'name': name.trim(),
          'createdAt': DateTime.now().toIso8601String(),
          'isActive': true,
        },
      );
    });
  }

  Future<void> deleteWorker(int workerId) async {
    final existing = await (_database.select(
      _database.workers,
    )..where((table) => table.id.equals(workerId))).getSingleOrNull();
    if (existing == null) {
      return;
    }

    await _database.transaction(() async {
      await (_database.update(_database.workers)
            ..where((table) => table.id.equals(workerId)))
          .write(const WorkersCompanion(isActive: Value(false)));

      await _queueSync(
        operation: SyncQueueOperation.update,
        tableName: 'workers',
        recordId: workerId,
        payload: <String, dynamic>{
          'id': existing.id,
          'name': existing.name,
          'createdAt': existing.createdAt.toIso8601String(),
          'isActive': false,
        },
      );
    });
  }

  Future<void> addOrUpdateProduction({
    int? productionId,
    required int workerId,
    required DateTime date,
    required int stitchCount,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final normalizedDate = _dayStart(date);

      late final int id;
      late final SyncQueueOperation operation;

      if (productionId == null) {
        final existing = await _findProductionForDay(
          workerId: workerId,
          date: normalizedDate,
        );

        if (existing == null) {
          id = await _database
              .into(_database.workerProductionEntries)
              .insert(
                WorkerProductionEntriesCompanion.insert(
                  workerId: workerId,
                  date: normalizedDate,
                  stitchCount: stitchCount,
                  notes: Value(notes),
                ),
              );
          operation = SyncQueueOperation.insert;
        } else {
          await (_database.update(
            _database.workerProductionEntries,
          )..where((table) => table.id.equals(existing.id))).write(
            WorkerProductionEntriesCompanion(
              date: Value(normalizedDate),
              stitchCount: Value(existing.stitchCount + stitchCount),
              notes: Value(_mergeNotes(existing.notes, notes)),
            ),
          );
          id = existing.id;
          operation = SyncQueueOperation.update;
        }
      } else {
        final existingForDay = await _findProductionForDay(
          workerId: workerId,
          date: normalizedDate,
          excludingId: productionId,
        );

        if (existingForDay == null) {
          await (_database.update(
            _database.workerProductionEntries,
          )..where((table) => table.id.equals(productionId))).write(
            WorkerProductionEntriesCompanion(
              workerId: Value(workerId),
              date: Value(normalizedDate),
              stitchCount: Value(stitchCount),
              notes: Value(notes),
            ),
          );
          id = productionId;
          operation = SyncQueueOperation.update;
        } else {
          await (_database.update(
            _database.workerProductionEntries,
          )..where((table) => table.id.equals(existingForDay.id))).write(
            WorkerProductionEntriesCompanion(
              date: Value(normalizedDate),
              stitchCount: Value(existingForDay.stitchCount + stitchCount),
              notes: Value(_mergeNotes(existingForDay.notes, notes)),
            ),
          );
          await (_database.delete(
            _database.workerProductionEntries,
          )..where((table) => table.id.equals(productionId))).go();
          await _queueSync(
            operation: SyncQueueOperation.delete,
            tableName: 'worker_production',
            recordId: productionId,
            payload: <String, dynamic>{
              'id': productionId,
              'workerId': workerId,
            },
          );
          id = existingForDay.id;
          operation = SyncQueueOperation.update;
        }
      }

      await _queueSync(
        operation: operation,
        tableName: 'worker_production',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'workerId': workerId,
          'date': normalizedDate.toIso8601String(),
          'stitchCount': await _currentStitchCount(id),
          'notes': await _currentProductionNotes(id),
        },
      );
    });
  }

  Future<void> deleteProduction(int productionId) async {
    final existing = await (_database.select(
      _database.workerProductionEntries,
    )..where((table) => table.id.equals(productionId))).getSingleOrNull();
    if (existing == null) {
      return;
    }

    await _database.transaction(() async {
      await (_database.delete(
        _database.workerProductionEntries,
      )..where((table) => table.id.equals(productionId))).go();

      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'worker_production',
        recordId: productionId,
        payload: <String, dynamic>{
          'id': productionId,
          'workerId': existing.workerId,
        },
      );
    });
  }

  Future<void> addAdvance({
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.workerAdvances)
          .insert(
            WorkerAdvancesCompanion.insert(
              workerId: workerId,
              amount: amount,
              date: date,
              notes: Value(notes),
            ),
          );

      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'worker_advances',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'workerId': workerId,
          'amount': amount,
          'date': date.toIso8601String(),
          'notes': notes,
          'carriedOver': false,
        },
      );
    });
  }

  Future<void> deleteAdvance(int advanceId) async {
    final existing = await (_database.select(
      _database.workerAdvances,
    )..where((table) => table.id.equals(advanceId))).getSingleOrNull();
    if (existing == null) {
      return;
    }

    await _database.transaction(() async {
      await (_database.delete(
        _database.workerAdvances,
      )..where((table) => table.id.equals(advanceId))).go();

      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'worker_advances',
        recordId: advanceId,
        payload: <String, dynamic>{
          'id': advanceId,
          'workerId': existing.workerId,
        },
      );
    });
  }

  Future<void> upsertAbsentDays({
    required int workerId,
    required DateTime month,
    required int absentDays,
  }) async {
    final normalizedMonth = _monthStart(month);
    await _database.transaction(() async {
      final existing =
          await (_database.select(_database.workerAbsentDays)..where(
                (table) =>
                    table.workerId.equals(workerId) &
                    table.monthStart.equals(normalizedMonth),
              ))
              .getSingleOrNull();

      late final int id;
      late final SyncQueueOperation operation;

      if (existing == null) {
        id = await _database
            .into(_database.workerAbsentDays)
            .insert(
              WorkerAbsentDaysCompanion.insert(
                workerId: workerId,
                monthStart: normalizedMonth,
                absentDays: Value(absentDays),
              ),
            );
        operation = SyncQueueOperation.insert;
      } else {
        await (_database.update(_database.workerAbsentDays)
              ..where((table) => table.id.equals(existing.id)))
            .write(WorkerAbsentDaysCompanion(absentDays: Value(absentDays)));
        id = existing.id;
        operation = SyncQueueOperation.update;
      }

      await _queueSync(
        operation: operation,
        tableName: 'worker_absent_days',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'workerId': workerId,
          'monthStart': normalizedMonth.toIso8601String(),
          'absentDays': absentDays,
        },
      );
    });
  }

  Future<void> updateStitchRate({
    required double rate,
    required DateTime effectiveFrom,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.stitchRates)
          .insert(
            StitchRatesCompanion.insert(
              rate: rate,
              effectiveFrom: effectiveFrom,
            ),
          );

      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'stitch_rate',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'rate': rate,
          'effectiveFrom': effectiveFrom.toIso8601String(),
        },
      );
    });
  }

  Stream<List<QueryRow>> _watchWorkersTrigger() {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.workers,
            _database.workerProductionEntries,
            _database.workerAdvances,
            _database.stitchRates,
            _database.workerAbsentDays,
          },
        )
        .watch();
  }

  Future<List<WorkerListItem>> _buildWorkerList(DateTime month) async {
    final workerRows =
        await (_database.select(_database.workers)
              ..where((table) => table.isActive.equals(true))
              ..orderBy([(table) => OrderingTerm(expression: table.name)]))
            .get();

    final items = <WorkerListItem>[];
    for (final row in workerRows) {
      final summary = await _buildSummary(row.id, month);
      items.add(
        WorkerListItem(
          id: row.id,
          name: row.name,
          totalEarnings: summary.totalEarnings,
          totalAdvances: summary.totalAdvances,
          netSalary: summary.netSalary,
        ),
      );
    }
    return items;
  }

  Future<WorkerDetailsData> _buildWorkerDetails(
    int workerId,
    DateTime month,
  ) async {
    final workerRow = await (_database.select(
      _database.workers,
    )..where((table) => table.id.equals(workerId))).getSingle();

    final summary = await _buildSummary(workerId, month);
    final monthRange = _monthRange(month);

    final productionRows =
        await (_database.select(_database.workerProductionEntries)
              ..where(
                (table) =>
                    table.workerId.equals(workerId) &
                    table.date.isBetweenValues(
                      monthRange.start,
                      monthRange.end,
                    ),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.date)]))
            .get();

    final productions = <WorkerProduction>[];
    for (final row in productionRows) {
      productions.add(
        WorkerProduction(
          id: row.id,
          workerId: row.workerId,
          date: row.date,
          stitchCount: row.stitchCount,
          notes: row.notes,
          dailyEarnings: await _calculateProductionEarnings(
            row.date,
            row.stitchCount,
          ),
        ),
      );
    }

    final advanceRows =
        await (_database.select(_database.workerAdvances)
              ..where(
                (table) =>
                    table.workerId.equals(workerId) &
                    table.date.isBetweenValues(
                      monthRange.start,
                      monthRange.end,
                    ),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.date)]))
            .get();

    final advances = <WorkerAdvance>[
      if (summary.carryOver > 0)
        WorkerAdvance(
          id: -summary.month.millisecondsSinceEpoch,
          workerId: workerId,
          amount: summary.carryOver,
          date: summary.month,
          notes: 'carry-over',
          carriedOver: true,
        ),
      ...advanceRows.map(
        (row) => WorkerAdvance(
          id: row.id,
          workerId: row.workerId,
          amount: row.amount,
          date: row.date,
          notes: row.notes,
          carriedOver: row.carriedOver,
        ),
      ),
    ];

    return WorkerDetailsData(
      worker: Worker(
        id: workerRow.id,
        name: workerRow.name,
        createdAt: workerRow.createdAt,
        isActive: workerRow.isActive,
      ),
      summary: summary,
      productions: productions,
      advances: advances,
    );
  }

  Future<WorkerMonthSummary> _buildSummary(int workerId, DateTime month) async {
    final normalizedMonth = _monthStart(month);
    final worker = await (_database.select(
      _database.workers,
    )..where((table) => table.id.equals(workerId))).getSingle();

    final productionRows = await (_database.select(
      _database.workerProductionEntries,
    )..where((table) => table.workerId.equals(workerId))).get();
    final advanceRows = await (_database.select(
      _database.workerAdvances,
    )..where((table) => table.workerId.equals(workerId))).get();
    final absentRow =
        await (_database.select(_database.workerAbsentDays)..where(
              (table) =>
                  table.workerId.equals(workerId) &
                  table.monthStart.equals(normalizedMonth),
            ))
            .getSingleOrNull();

    final monthlyBalances = <DateTime, _MonthBalance>{};
    final firstMonth = _monthStart(worker.createdAt);

    for (final production in productionRows) {
      final key = _monthStart(production.date);
      final existing = monthlyBalances[key] ?? const _MonthBalance();
      monthlyBalances[key] = existing.copyWith(
        stitchCount: existing.stitchCount + production.stitchCount,
        earnings:
            existing.earnings +
            await _calculateProductionEarnings(
              production.date,
              production.stitchCount,
            ),
      );
    }

    for (final advance in advanceRows) {
      final key = _monthStart(advance.date);
      final existing = monthlyBalances[key] ?? const _MonthBalance();
      monthlyBalances[key] = existing.copyWith(
        advances: existing.advances + advance.amount,
      );
    }

    double carryIn = 0;
    DateTime cursor = firstMonth;
    while (!_isAfterMonth(cursor, normalizedMonth)) {
      final data = monthlyBalances[cursor] ?? const _MonthBalance();
      final net = data.earnings - data.advances - carryIn;
      final nextCarry = net < 0 ? -net : 0;

      if (_sameMonth(cursor, normalizedMonth)) {
        final rate = await _rateForMonth(normalizedMonth);
        return WorkerMonthSummary(
          month: normalizedMonth,
          totalStitchCount: data.stitchCount,
          totalEarnings: data.earnings,
          totalAdvances: data.advances,
          carryOver: carryIn,
          absentDays: absentRow?.absentDays ?? 0,
          netSalary: net,
          appliedRate: rate,
        );
      }

      carryIn = nextCarry.toDouble();
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    return WorkerMonthSummary(
      month: normalizedMonth,
      totalStitchCount: 0,
      totalEarnings: 0,
      totalAdvances: 0,
      carryOver: carryIn,
      absentDays: absentRow?.absentDays ?? 0,
      netSalary: -carryIn,
      appliedRate: await _rateForMonth(normalizedMonth),
    );
  }

  Future<double> _calculateProductionEarnings(
    DateTime date,
    int stitchCount,
  ) async {
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    final rate = await _rateForDate(endOfDay);
    return ((stitchCount / 100000) * rate).toDouble();
  }

  Future<double> _rateForMonth(DateTime month) async {
    return _rateForDate(_monthRange(month).end);
  }

  Future<double> _rateForDate(DateTime date) async {
    final rateRow =
        await (_database.select(_database.stitchRates)
              ..where(
                (table) => table.effectiveFrom.isSmallerOrEqualValue(date),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.effectiveFrom)])
              ..limit(1))
            .getSingleOrNull();
    return rateRow?.rate ?? 0;
  }

  Future<void> _queueSync({
    required SyncQueueOperation operation,
    required String tableName,
    required int recordId,
    required Map<String, dynamic> payload,
  }) async {
    await _database
        .into(_database.syncQueue)
        .insert(
          SyncQueueCompanion.insert(
            operation: operation,
            targetTableName: tableName,
            recordId: recordId,
            payload: jsonEncode(payload),
          ),
        );
  }

  DateTime _monthStart(DateTime date) => DateTime(date.year, date.month);

  DateTime _dayStart(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<WorkerProductionEntry?> _findProductionForDay({
    required int workerId,
    required DateTime date,
    int? excludingId,
  }) {
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    final query = _database.select(_database.workerProductionEntries)
      ..where(
        (table) =>
            table.workerId.equals(workerId) &
            table.date.isBetweenValues(date, endOfDay) &
            (excludingId == null
                ? const Constant(true)
                : table.id.isNotValue(excludingId)),
      )
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<int> _currentStitchCount(int productionId) async {
    final row = await (_database.select(
      _database.workerProductionEntries,
    )..where((table) => table.id.equals(productionId))).getSingle();
    return row.stitchCount;
  }

  Future<String?> _currentProductionNotes(int productionId) async {
    final row = await (_database.select(
      _database.workerProductionEntries,
    )..where((table) => table.id.equals(productionId))).getSingle();
    return row.notes;
  }

  String? _mergeNotes(String? currentNotes, String? incomingNotes) {
    final current = currentNotes?.trim();
    final incoming = incomingNotes?.trim();

    if (current == null || current.isEmpty) {
      return incoming == null || incoming.isEmpty ? null : incoming;
    }
    if (incoming == null || incoming.isEmpty) {
      return current;
    }
    if (current == incoming) {
      return current;
    }
    return '$current | $incoming';
  }

  ({DateTime start, DateTime end}) _monthRange(DateTime date) {
    final start = _monthStart(date);
    final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
    return (start: start, end: end);
  }

  bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  bool _isAfterMonth(DateTime value, DateTime target) {
    return value.year > target.year ||
        (value.year == target.year && value.month > target.month);
  }
}

class _MonthBalance {
  const _MonthBalance({
    this.stitchCount = 0,
    this.earnings = 0,
    this.advances = 0,
  });

  final int stitchCount;
  final double earnings;
  final double advances;

  _MonthBalance copyWith({
    int? stitchCount,
    double? earnings,
    double? advances,
  }) {
    return _MonthBalance(
      stitchCount: stitchCount ?? this.stitchCount,
      earnings: earnings ?? this.earnings,
      advances: advances ?? this.advances,
    );
  }
}
