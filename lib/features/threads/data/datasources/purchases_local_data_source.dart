import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide Supplier, ThreadPurchase;
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/thread_purchase.dart';
import 'threads_db_helpers.dart';

@lazySingleton
class PurchasesLocalDataSource {
  PurchasesLocalDataSource(this._database);

  final AppDatabase _database;

  Stream<List<ThreadPurchase>> watchAllPurchases(DateTime month) =>
      watchTrigger(_database).asyncMap((_) => _buildAll(month));

  Future<void> addPurchase({
    required int supplierId,
    required String itemName,
    required String colorNumber,
    required DateTime purchaseDate,
    required double price,
    required double quantity,
    required String unit,
    String? notes,
  }) => addOrUpdatePurchase(
    supplierId: supplierId,
    itemName: itemName,
    colorNumber: colorNumber,
    purchaseDate: purchaseDate,
    price: price,
    quantity: quantity,
    unit: unit,
    notes: notes,
  );

  Future<void> addOrUpdatePurchase({
    int? purchaseId,
    required int supplierId,
    required String itemName,
    required String colorNumber,
    required DateTime purchaseDate,
    required double price,
    required double quantity,
    required String unit,
    String? notes,
  }) async {
    await _database.transaction(() async {
      late final int id;
      late final SyncQueueOperation op;
      if (purchaseId == null) {
        id = await _database
            .into(_database.threadPurchases)
            .insert(
              ThreadPurchasesCompanion.insert(
                supplierId: supplierId,
                itemName: itemName.trim(),
                colorNumber: colorNumber.trim(),
                purchaseDate: purchaseDate,
                price: price,
                quantity: quantity,
                unit: unit.trim(),
                notes: Value(notes),
              ),
            );
        op = SyncQueueOperation.insert;
      } else {
        await (_database.update(
          _database.threadPurchases,
        )..where((t) => t.id.equals(purchaseId))).write(
          ThreadPurchasesCompanion(
            supplierId: Value(supplierId),
            itemName: Value(itemName.trim()),
            colorNumber: Value(colorNumber.trim()),
            purchaseDate: Value(purchaseDate),
            price: Value(price),
            quantity: Value(quantity),
            unit: Value(unit.trim()),
            notes: Value(notes),
          ),
        );
        id = purchaseId;
        op = SyncQueueOperation.update;
      }
      await queueSync(
        database: _database,
        operation: op,
        tableName: 'thread_purchases',
        recordId: id,
        payload: _payload(
          id,
          supplierId,
          itemName,
          colorNumber,
          purchaseDate,
          price,
          quantity,
          unit,
          notes,
        ),
      );
    });
  }

  Future<void> deletePurchase(int pid) async {
    await _database.transaction(() async {
      final row = await (_database.select(
        _database.threadPurchases,
      )..where((t) => t.id.equals(pid))).getSingleOrNull();
      if (row == null) return;
      await (_database.delete(
        _database.threadPurchases,
      )..where((t) => t.id.equals(pid))).go();
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.delete,
        tableName: 'thread_purchases',
        recordId: pid,
        payload: <String, dynamic>{'id': pid, 'supplierId': row.supplierId},
      );
    });
  }

  Future<List<ThreadPurchase>> _buildAll(DateTime month) async {
    final r = monthRange(month);
    final rows =
        await (_database.select(_database.threadPurchases)
              ..where((t) => t.purchaseDate.isBetweenValues(r.start, r.end))
              ..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)]))
            .get();
    return rows
        .map(
          (row) => ThreadPurchase(
            id: row.id,
            supplierId: row.supplierId,
            itemName: row.itemName,
            colorNumber: row.colorNumber,
            purchaseDate: row.purchaseDate,
            price: row.price,
            quantity: row.quantity,
            unit: row.unit,
            notes: row.notes,
          ),
        )
        .toList();
  }

  Map<String, dynamic> _payload(
    int id,
    int sid,
    String item,
    String color,
    DateTime date,
    double price,
    double qty,
    String unit,
    String? notes,
  ) => <String, dynamic>{
    'id': id,
    'supplierId': sid,
    'itemName': item.trim(),
    'colorNumber': color.trim(),
    'purchaseDate': date.toIso8601String(),
    'price': price,
    'quantity': qty,
    'unit': unit.trim(),
    'notes': notes,
  };
}
