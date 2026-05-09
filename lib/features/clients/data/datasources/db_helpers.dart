import 'dart:convert';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_queue_table.dart';

({DateTime start, DateTime end}) monthRange(DateTime month) {
  final start = DateTime(month.year, month.month);
  final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
  return (start: start, end: end);
}

Future<void> queueSyncEntry(
  AppDatabase database, {
  required SyncQueueOperation operation,
  required String tableName,
  required int recordId,
  required Map<String, dynamic> payload,
}) {
  return database
      .into(database.syncQueue)
      .insert(
        SyncQueueCompanion.insert(
          operation: operation,
          targetTableName: tableName,
          recordId: recordId,
          payload: jsonEncode(payload),
        ),
      );
}
