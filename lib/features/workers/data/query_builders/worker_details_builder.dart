import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide Worker, WorkerAdvance;
import '../../domain/entities/worker.dart';
import '../../domain/entities/worker_advance.dart';
import '../../domain/entities/worker_details_data.dart';
import '../../domain/entities/worker_production.dart';
import '../helpers/worker_date_utils.dart';
import '../helpers/worker_earnings_helper.dart';
import 'worker_summary_builder.dart';

@injectable
class WorkerDetailsBuilder {
  WorkerDetailsBuilder(
    this._database,
    this._earningsHelper,
    this._summaryBuilder,
  );

  final AppDatabase _database;
  final WorkerEarningsHelper _earningsHelper;
  final WorkerSummaryBuilder _summaryBuilder;

  Future<WorkerDetailsData> buildWorkerDetails(
    int workerId,
    DateTime month,
  ) async {
    final workerRow = await (_database.select(
      _database.workers,
    )..where((table) => table.id.equals(workerId))).getSingle();

    final summary = await _summaryBuilder.buildSummary(workerId, month);
    final range = monthRange(month);

    final productionRows =
        await (_database.select(_database.workerProductionEntries)
              ..where(
                (table) =>
                    table.workerId.equals(workerId) &
                    table.date.isBetweenValues(range.start, range.end),
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
          dailyEarnings:
              await _earningsHelper.calculateProductionEarnings(
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
                    table.date.isBetweenValues(range.start, range.end),
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
}
