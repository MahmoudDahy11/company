import 'dart:async';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../helpers/worker_sync_helper.dart';

@lazySingleton
class WorkerRateDataSource {
  const WorkerRateDataSource(this._database);

  final AppDatabase _database;

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

      await queueSync(
        _database,
        operation: SyncQueueOperation.insert,
        tableName: 'stitch_rate',
        recordId: id,
        payload: (await (_database.select(_database.stitchRates)
              ..where((t) => t.id.equals(id)))
            .getSingle()).toJson(),
      );
    });
  }
}
