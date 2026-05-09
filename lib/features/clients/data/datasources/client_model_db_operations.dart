import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' hide Client;
import '../../../../core/sync/sync_queue_table.dart';
import 'db_helpers.dart';

class ModelDbOperations {
  ModelDbOperations(this._database);

  final AppDatabase _database;

  Future<void> addModel({
    required int clientId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.clientModels)
          .insert(
            ClientModelsCompanion.insert(
              clientId: clientId,
              modelName: modelName.trim(),
              pieceCount: pieceCount,
              pricePerPiece: pricePerPiece,
              date: date,
              notes: Value(notes),
            ),
          );
      final model = await (_database.select(
        _database.clientModels,
      )..where((t) => t.id.equals(id))).getSingle();
      await queueSyncEntry(
        _database,
        operation: SyncQueueOperation.insert,
        tableName: 'client_models',
        recordId: id,
        payload: model.toJson(),
      );
    });
  }

  Future<void> updateModel({
    required int modelId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final existing = await (_database.select(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).getSingleOrNull();
      if (existing == null) return;

      await (_database.update(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).write(
        ClientModelsCompanion(
          modelName: Value(modelName.trim()),
          pieceCount: Value(pieceCount),
          pricePerPiece: Value(pricePerPiece),
          date: Value(date),
          notes: Value(notes),
        ),
      );

      final updated = await (_database.select(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).getSingle();
      await queueSyncEntry(
        _database,
        operation: SyncQueueOperation.update,
        tableName: 'client_models',
        recordId: modelId,
        payload: updated.toJson(),
      );
    });
  }

  Future<void> deleteModel(int modelId) async {
    await _database.transaction(() async {
      final row = await (_database.select(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).getSingleOrNull();
      if (row == null) return;

      await (_database.delete(
        _database.clientModels,
      )..where((t) => t.id.equals(modelId))).go();

      await queueSyncEntry(
        _database,
        operation: SyncQueueOperation.delete,
        tableName: 'client_models',
        recordId: modelId,
        payload: {'id': modelId, 'clientId': row.clientId},
      );
    });
  }
}
