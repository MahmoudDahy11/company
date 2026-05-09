import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide Worker, WorkerAdvance, WorkerDeduction;
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/worker.dart';
import '../../domain/entities/worker_advance.dart';
import '../../domain/entities/worker_deduction.dart';
import '../../domain/entities/worker_details_data.dart';
import '../../domain/entities/worker_list_item.dart';
import '../../domain/entities/worker_month_summary.dart';
import '../../domain/entities/worker_production.dart';

import '../../domain/usecases/calculate_worker_salary_usecase.dart';

@lazySingleton
class WorkersLocalDataSource {
  const WorkersLocalDataSource(
    this._database,
    this._calculateWorkerSalaryUseCase,
  );

  final AppDatabase _database;
  final CalculateWorkerSalaryUseCase _calculateWorkerSalaryUseCase;

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

      final row = await (_database.select(
        _database.workers,
      )..where((t) => t.id.equals(id))).getSingle();

      await _queueSync(
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
        payload: (await (_database.select(
          _database.workers,
        )..where((t) => t.id.equals(workerId))).getSingle()).toJson(),
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
        payload: (await (_database.select(
          _database.workerProductionEntries,
        )..where((t) => t.id.equals(id))).getSingle()).toJson(),
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
        payload: (await (_database.select(
          _database.workerAdvances,
        )..where((t) => t.id.equals(id))).getSingle()).toJson(),
      );
    });
  }

  Future<void> addOrUpdateAdvance({
    int? advanceId,
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      late final int id;
      late final SyncQueueOperation operation;

      if (advanceId == null) {
        id = await _database
            .into(_database.workerAdvances)
            .insert(
              WorkerAdvancesCompanion.insert(
                workerId: workerId,
                amount: amount,
                date: date,
                notes: Value(notes),
              ),
            );
        operation = SyncQueueOperation.insert;
      } else {
        await (_database.update(
          _database.workerAdvances,
        )..where((table) => table.id.equals(advanceId))).write(
          WorkerAdvancesCompanion(
            workerId: Value(workerId),
            amount: Value(amount),
            date: Value(date),
            notes: Value(notes),
          ),
        );
        id = advanceId;
        operation = SyncQueueOperation.update;
      }

      await _queueSync(
        operation: operation,
        tableName: 'worker_advances',
        recordId: id,
        payload: (await (_database.select(
          _database.workerAdvances,
        )..where((t) => t.id.equals(id))).getSingle()).toJson(),
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

  Future<void> addDeduction({
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.workerDeductions)
          .insert(
            WorkerDeductionsCompanion.insert(
              workerId: workerId,
              amount: amount,
              date: date,
              notes: Value(notes),
            ),
          );

      final row = await (_database.select(
        _database.workerDeductions,
      )..where((t) => t.id.equals(id))).getSingle();

      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'worker_deductions',
        recordId: id,
        payload: row.toJson(),
      );
    });
  }

  Future<void> deleteDeduction(int deductionId) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.workerDeductions,
      )..where((t) => t.id.equals(deductionId))).go();

      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'worker_deductions',
        recordId: deductionId,
        payload: {},
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
        payload: (await (_database.select(
          _database.workerAbsentDays,
        )..where((t) => t.id.equals(id))).getSingle()).toJson(),
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
        payload: (await (_database.select(
          _database.stitchRates,
        )..where((t) => t.id.equals(id))).getSingle()).toJson(),
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
            _database.workerDeductions,
          },
        )
        .watch();
  }

  Future<List<WorkerListItem>> _buildWorkerList(DateTime month) async {
    final range = _monthRange(month);
    final rate = await _rateForMonth(month);

    final query = _database.customSelect(
      '''
      SELECT 
        w.id, 
        w.name,
        COALESCE((SELECT SUM(stitch_count) FROM worker_production_entries WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0) as current_stitches,
        COALESCE((SELECT SUM(amount) FROM worker_advances WHERE worker_id = w.id AND date BETWEEN ? AND ? AND carried_over = 0), 0) as current_advances,
        COALESCE((SELECT SUM(amount) FROM worker_deductions WHERE worker_id = w.id AND date BETWEEN ? AND ?), 0) as current_deductions,
        COALESCE((SELECT amount FROM worker_advances WHERE worker_id = w.id AND date = ? AND carried_over = 1 LIMIT 1), -1.0) as carry_in
      FROM workers w
      WHERE w.is_active = 1
      ORDER BY w.name ASC
      ''',
      variables: [
        Variable.withDateTime(range.start),
        Variable.withDateTime(range.end),
        Variable.withDateTime(range.start),
        Variable.withDateTime(range.end),
        Variable.withDateTime(range.start),
        Variable.withDateTime(range.end),
        Variable.withDateTime(range.start),
      ],
      readsFrom: {
        _database.workers,
        _database.workerProductionEntries,
        _database.workerAdvances,
        _database.workerDeductions,
      },
    );

    final rows = await query.get();
    final items = <WorkerListItem>[];

    for (final row in rows) {
      final workerId = row.read<int>('id');
      final name = row.read<String>('name');
      final currentStitches = row.read<int>('current_stitches');
      final currentAdvances = row.read<double>('current_advances');
      final currentDeductions = row.read<double>('current_deductions');
      var carryIn = row.read<double>('carry_in');

      // If no carry-over record found (-1.0), calculate and potentially persist it
      if (carryIn < 0) {
        carryIn = await _getOrCalculateCarryIn(workerId, month);
      }

      final earnings = (currentStitches / 100000.0) * rate;
      final summary = _calculateWorkerSalaryUseCase(
        month: month,
        stitchCount: currentStitches,
        earnings: earnings,
        advances: currentAdvances,
        deductions: currentDeductions,
        carryOver: carryIn,
        absentDays: 0, // Not needed for list item
        appliedRate: rate,
      );

      items.add(
        WorkerListItem(
          id: workerId,
          name: name,
          totalEarnings: summary.totalEarnings,
          totalAdvances: summary.totalAdvances,
          totalDeductions: summary.totalDeductions,
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

    final deductionRows =
        await (_database.select(_database.workerDeductions)
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

    final deductions = deductionRows
        .map(
          (row) => WorkerDeduction(
            id: row.id,
            workerId: row.workerId,
            amount: row.amount,
            date: row.date,
            notes: row.notes,
          ),
        )
        .toList();

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
      deductions: deductions,
    );
  }

  Future<WorkerMonthSummary> _buildSummary(int workerId, DateTime month) async {
    final normalizedMonth = _monthStart(month);
    final range = _monthRange(normalizedMonth);

    // Get current month data ONLY (no more fetching all history)
    final productionRows =
        await (_database.select(_database.workerProductionEntries)..where(
              (table) =>
                  table.workerId.equals(workerId) &
                  table.date.isBetweenValues(range.start, range.end),
            ))
            .get();

    final advanceRows =
        await (_database.select(_database.workerAdvances)..where(
              (table) =>
                  table.workerId.equals(workerId) &
                  table.date.isBetweenValues(range.start, range.end) &
                  table.carriedOver.equals(false),
            ))
            .get();

    final deductionRows =
        await (_database.select(_database.workerDeductions)..where(
              (table) =>
                  table.workerId.equals(workerId) &
                  table.date.isBetweenValues(range.start, range.end),
            ))
            .get();

    final absentRow =
        await (_database.select(_database.workerAbsentDays)..where(
              (table) =>
                  table.workerId.equals(workerId) &
                  table.monthStart.equals(normalizedMonth),
            ))
            .getSingleOrNull();

    // 1. Calculate current month's totals
    int totalStitches = 0;
    double earnings = 0;
    for (final production in productionRows) {
      totalStitches += production.stitchCount;
      earnings += await _calculateProductionEarnings(
        production.date,
        production.stitchCount,
      );
    }

    double advances = 0;
    for (final advance in advanceRows) {
      advances += advance.amount;
    }

    double deductions = 0;
    for (final deduction in deductionRows) {
      deductions += deduction.amount;
    }

    // 2. Get Carry-over from previous month (optimized)
    final carryIn = await _getOrCalculateCarryIn(workerId, normalizedMonth);

    final rate = await _rateForMonth(normalizedMonth);

    // 3. Use Domain UseCase for salary calculation
    return _calculateWorkerSalaryUseCase(
      month: normalizedMonth,
      stitchCount: totalStitches,
      earnings: earnings,
      advances: advances,
      deductions: deductions,
      carryOver: carryIn,
      absentDays: absentRow?.absentDays ?? 0,
      appliedRate: rate,
    );
  }

  Future<double> _getOrCalculateCarryIn(int workerId, DateTime month) async {
    final normalizedMonth = _monthStart(month);

    // 1. Check for existing carry-over record for this month
    final existing =
        await (_database.select(_database.workerAdvances)..where(
              (t) =>
                  t.workerId.equals(workerId) &
                  t.date.equals(normalizedMonth) &
                  t.carriedOver.equals(true),
            ))
            .getSingleOrNull();

    if (existing != null) return existing.amount.toDouble();

    // 2. Fallback: If this is the worker's start month, carry-over is 0
    final worker = await (_database.select(
      _database.workers,
    )..where((t) => t.id.equals(workerId))).getSingle();

    if (!_isAfterMonth(normalizedMonth, _monthStart(worker.createdAt))) {
      return 0;
    }

    // 3. Otherwise, calculate previous month's summary recursively
    final prevMonth = DateTime(normalizedMonth.year, normalizedMonth.month - 1);
    final prevSummary = await _buildSummary(workerId, prevMonth);

    final carryOver = prevSummary.netSalary < 0 ? -prevSummary.netSalary : 0.0;

    // 4. Persist this carry-over record to break the chain for future calls
    if (carryOver > 0) {
      await _database
          .into(_database.workerAdvances)
          .insert(
            WorkerAdvancesCompanion.insert(
              workerId: workerId,
              amount: carryOver,
              date: normalizedMonth,
              notes: const Value('Carry-over'),
              carriedOver: const Value(true),
            ),
          );

      // Also queue sync for consistency
      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'worker_advances',
        recordId: -1, // Temporary, will be handled locally
        payload: {
          'workerId': workerId,
          'amount': carryOver,
          'date': normalizedMonth.toIso8601String(),
          'notes': 'Carry-over',
          'carriedOver': true,
        },
      );
    }

    return carryOver.toDouble();
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

  bool _isAfterMonth(DateTime value, DateTime target) {
    return value.year > target.year ||
        (value.year == target.year && value.month > target.month);
  }
}
