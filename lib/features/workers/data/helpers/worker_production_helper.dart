import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

Future<WorkerProductionEntry?> findProductionForDay(
  AppDatabase database, {
  required int workerId,
  required DateTime date,
  int? excludingId,
}) {
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  final query = database.select(database.workerProductionEntries)
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

String? mergeNotes(String? currentNotes, String? incomingNotes) {
  final current = currentNotes?.trim();
  final incoming = incomingNotes?.trim();
  if (current == null || current.isEmpty) {
    return incoming == null || incoming.isEmpty ? null : incoming;
  }
  if (incoming == null || incoming.isEmpty) return current;
  if (current == incoming) return current;
  return '$current | $incoming';
}
