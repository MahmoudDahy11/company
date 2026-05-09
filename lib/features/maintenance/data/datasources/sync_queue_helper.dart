import 'dart:convert';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_queue_table.dart';

class SyncQueueHelper {
  const SyncQueueHelper(this._database);

  final AppDatabase _database;

  Future<void> queueSync({
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
}
