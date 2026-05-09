import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/worker_list_item.dart';
import '../../domain/usecases/calculate_worker_salary_usecase.dart';
import '../helpers/worker_date_utils.dart';
import '../helpers/worker_earnings_helper.dart';
import 'worker_summary_builder.dart';

@injectable
class WorkerListBuilder {
  WorkerListBuilder(
    this._database,
    this._earningsHelper,
    this._calculateWorkerSalaryUseCase,
    this._summaryBuilder,
  );

  final AppDatabase _database;
  final WorkerEarningsHelper _earningsHelper;
  final CalculateWorkerSalaryUseCase _calculateWorkerSalaryUseCase;
  final WorkerSummaryBuilder _summaryBuilder;

  /// watcher for workers
  Stream<List<QueryRow>> watchWorkersTrigger() {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.workers,
            _database.workerProductionEntries,
            _database.workerAdvances,
            _database.workerDeductions,
            _database.stitchRates,
            _database.workerAbsentDays,
          },
        )
        .watch();
  }

  Future<List<WorkerListItem>> buildWorkerList(DateTime month) async {
    final range = monthRange(month);
    final rate = await _earningsHelper.rateForMonth(month);

    final query = _database.customSelect(
      '''
      SELECT 
        w.id, w.name,
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

      if (carryIn < 0) {
        carryIn = await _summaryBuilder.getOrCalculateCarryIn(workerId, month);
      }

      final earnings = (currentStitches / 100000.0) * rate;
      final summary = _calculateWorkerSalaryUseCase(
        month: month,
        stitchCount: currentStitches,
        earnings: earnings,
        advances: currentAdvances,
        deductions: currentDeductions,
        carryOver: carryIn,
        absentDays: 0,
        appliedRate: rate,
      );

      items.add(
        WorkerListItem(
          id: workerId,
          name: name,
          totalEarnings: summary.totalEarnings,
          totalAdvances: summary.totalAdvances,
          totalDeductions: summary.totalDeductions,
          absentDays: summary.absentDays,
          netSalary: summary.netSalary,
        ),
      );
    }
    return items;
  }
}
