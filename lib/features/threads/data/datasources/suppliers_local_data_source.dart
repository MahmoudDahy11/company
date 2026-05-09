import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide Supplier, ThreadPurchase;
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/supplier_list_item.dart';
import 'threads_db_helpers.dart';

@lazySingleton
class SuppliersLocalDataSource {
  SuppliersLocalDataSource(this._database);

  final AppDatabase _database;

  Stream<List<SupplierListItem>> watchSuppliers(DateTime month) {
    return watchTrigger(_database).asyncMap((_) => _buildSupplierList(month));
  }

  Future<void> addSupplier({required String name, String? phone}) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.suppliers)
          .insert(
            SuppliersCompanion.insert(
              name: name.trim(),
              phone: Value(
                phone?.trim().isEmpty == true ? null : phone?.trim(),
              ),
            ),
          );
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.insert,
        tableName: 'suppliers',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'name': name.trim(),
          'phone': phone?.trim(),
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
    });
  }

  Future<void> deleteSupplier(int supplierId) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.threadPurchases,
      )..where((t) => t.supplierId.equals(supplierId))).go();
      await (_database.delete(
        _database.supplierPayments,
      )..where((t) => t.supplierId.equals(supplierId))).go();
      await (_database.delete(
        _database.suppliers,
      )..where((t) => t.id.equals(supplierId))).go();
      await queueSync(
        database: _database,
        operation: SyncQueueOperation.delete,
        tableName: 'suppliers',
        recordId: supplierId,
        payload: <String, dynamic>{'id': supplierId},
      );
    });
  }

  Future<List<SupplierListItem>> _buildSupplierList(DateTime month) async {
    final range = monthRange(month);
    final query = '''
      SELECT s.id, s.name,
        (SELECT SUM(price) FROM thread_purchases WHERE supplier_id = s.id AND purchase_date BETWEEN ? AND ?) as total_purchased,
        (SELECT SUM(amount) FROM supplier_payments WHERE supplier_id = s.id AND payment_date BETWEEN ? AND ?) as total_paid
      FROM suppliers s ORDER BY s.name
    ''';
    final rows = await _database
        .customSelect(
          query,
          variables: [
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
          ],
        )
        .get();
    return rows.map((row) {
      final totalPurchased = row.read<double?>('total_purchased') ?? 0.0;
      final totalPaid = row.read<double?>('total_paid') ?? 0.0;
      return SupplierListItem(
        id: row.read<int>('id'),
        name: row.read<String>('name'),
        totalPurchased: totalPurchased,
        totalPaid: totalPaid,
        outstandingBalance: totalPurchased - totalPaid,
      );
    }).toList();
  }
}
