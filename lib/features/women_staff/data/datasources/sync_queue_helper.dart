import 'dart:convert';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_queue_table.dart';

Future<void> queueSync({
  required AppDatabase database,
  required SyncQueueOperation operation,
  required String tableName,
  required int recordId,
  required Map<String, dynamic> payload,
}) async {
  await database
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
