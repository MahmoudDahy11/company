import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/worker_month_summary.dart';
import '../../domain/usecases/calculate_worker_salary_usecase.dart';
import '../helpers/worker_date_utils.dart';
import '../helpers/worker_earnings_helper.dart';
import '../helpers/worker_sync_helper.dart';

@injectable
class WorkerSummaryBuilder {
  WorkerSummaryBuilder(
    this._database, this._earningsHelper, this._calculateWorkerSalaryUseCase,
  );

  final AppDatabase _database;
  final WorkerEarningsHelper _earningsHelper;
  final CalculateWorkerSalaryUseCase _calculateWorkerSalaryUseCase;

  Future<WorkerMonthSummary> buildSummary(int workerId, DateTime month) async {
    final normalizedMonth = monthStart(month);
    final range = monthRange(normalizedMonth);

    final productionRows = await (_database.select(_database.workerProductionEntries)..where(
      (table) => table.workerId.equals(workerId) &
          table.date.isBetweenValues(range.start, range.end),
    )).get();

    final advanceRows = await (_database.select(_database.workerAdvances)..where(
      (table) => table.workerId.equals(workerId) &
          table.date.isBetweenValues(range.start, range.end) &
          table.carriedOver.equals(false),
    )).get();

    final absentRow = await (_database.select(_database.workerAbsentDays)..where(
      (table) => table.workerId.equals(workerId) &
          table.monthStart.equals(normalizedMonth),
    )).getSingleOrNull();

    int totalStitches = 0;
    double earnings = 0;
    for (final production in productionRows) {
      totalStitches += production.stitchCount;
      earnings += await _earningsHelper.calculateProductionEarnings(
        production.date, production.stitchCount,
      );
    }

    double advances = 0;
    for (final advance in advanceRows) {
      advances += advance.amount;
    }

    final carryIn = await getOrCalculateCarryIn(workerId, normalizedMonth);
    final rate = await _earningsHelper.rateForMonth(normalizedMonth);

    return _calculateWorkerSalaryUseCase(
      month: normalizedMonth, stitchCount: totalStitches, earnings: earnings,
      advances: advances, carryOver: carryIn,
      absentDays: absentRow?.absentDays ?? 0, appliedRate: rate,
    );
  }

  Future<double> getOrCalculateCarryIn(int workerId, DateTime month) async {
    final normalizedMonth = monthStart(month);
    final existing = await (_database.select(_database.workerAdvances)..where(
      (t) => t.workerId.equals(workerId) &
          t.date.equals(normalizedMonth) & t.carriedOver.equals(true),
    )).getSingleOrNull();

    if (existing != null) return existing.amount.toDouble();

    final worker = await (_database.select(_database.workers)
      ..where((t) => t.id.equals(workerId))).getSingle();

    if (!isAfterMonth(normalizedMonth, monthStart(worker.createdAt))) return 0;

    final prevMonth = DateTime(normalizedMonth.year, normalizedMonth.month - 1);
    final prevSummary = await buildSummary(workerId, prevMonth);
    final carryOver = prevSummary.netSalary < 0 ? -prevSummary.netSalary : 0.0;

    if (carryOver > 0) {
      await _database.into(_database.workerAdvances).insert(
        WorkerAdvancesCompanion.insert(
          workerId: workerId, amount: carryOver, date: normalizedMonth,
          notes: const Value('Carry-over'), carriedOver: const Value(true),
        ),
      );
      await queueSync(_database,
        operation: SyncQueueOperation.insert, tableName: 'worker_advances',
        recordId: -1,
        payload: {
          'workerId': workerId, 'amount': carryOver,
          'date': normalizedMonth.toIso8601String(),
          'notes': 'Carry-over', 'carriedOver': true,
        },
      );
    }

    return carryOver.toDouble();
  }
}
