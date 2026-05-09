import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import 'worker_date_utils.dart';

@injectable
class WorkerEarningsHelper {
  const WorkerEarningsHelper(this._database);

  final AppDatabase _database;

  Future<double> rateForMonth(DateTime month) =>
      rateForDate(monthRange(month).end);

  Future<double> rateForDate(DateTime date) async {
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

  Future<double> calculateProductionEarnings(
    DateTime date,
    int stitchCount,
  ) async {
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    final rate = await rateForDate(endOfDay);
    return ((stitchCount / 100000) * rate).toDouble();
  }
}
