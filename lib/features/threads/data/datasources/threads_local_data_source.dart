import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide Supplier, ThreadPurchase;
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/entities/supplier_details_data.dart';
import '../../domain/entities/supplier_list_item.dart';
import '../../domain/entities/supplier_payment.dart';
import '../../domain/entities/supplier_summary.dart';
import '../../domain/entities/thread_purchase.dart';
import '../../domain/entities/threads_overview.dart';

@lazySingleton
class ThreadsLocalDataSource {
  ThreadsLocalDataSource(this._database);

  final AppDatabase _database;

  Stream<List<SupplierListItem>> watchSuppliers(DateTime month) {
    return _watchTrigger().asyncMap((_) => _buildSupplierList(month));
  }

  Stream<SupplierDetailsData> watchSupplierDetails(
    int supplierId,
    DateTime month,
  ) {
    return _watchTrigger().asyncMap(
      (_) => _buildSupplierDetails(supplierId, month),
    );
  }

  Stream<ThreadsOverview> watchOverview(DateTime month) {
    return _watchTrigger().asyncMap((_) => _buildOverview(month));
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

      await _queueSync(
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
      final purchaseRows = await (_database.select(
        _database.threadPurchases,
      )..where((t) => t.supplierId.equals(supplierId))).get();
      final paymentRows = await (_database.select(
        _database.supplierPayments,
      )..where((t) => t.supplierId.equals(supplierId))).get();

      for (final purchase in purchaseRows) {
        await (_database.delete(
          _database.threadPurchases,
        )..where((t) => t.id.equals(purchase.id))).go();
        await _queueSync(
          operation: SyncQueueOperation.delete,
          tableName: 'thread_purchases',
          recordId: purchase.id,
          payload: <String, dynamic>{
            'id': purchase.id,
            'supplierId': purchase.supplierId,
          },
        );
      }

      for (final payment in paymentRows) {
        await (_database.delete(
          _database.supplierPayments,
        )..where((t) => t.id.equals(payment.id))).go();
        await _queueSync(
          operation: SyncQueueOperation.delete,
          tableName: 'supplier_payments',
          recordId: payment.id,
          payload: <String, dynamic>{
            'id': payment.id,
            'supplierId': payment.supplierId,
          },
        );
      }

      await (_database.delete(
        _database.suppliers,
      )..where((t) => t.id.equals(supplierId))).go();
      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'suppliers',
        recordId: supplierId,
        payload: <String, dynamic>{'id': supplierId},
      );
    });
  }

  Future<void> addPurchase({
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
      final id = await _database
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
      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'thread_purchases',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'supplierId': supplierId,
          'itemName': itemName.trim(),
          'colorNumber': colorNumber.trim(),
          'purchaseDate': purchaseDate.toIso8601String(),
          'price': price,
          'quantity': quantity,
          'unit': unit.trim(),
          'notes': notes,
        },
      );
    });
  }

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
      late final SyncQueueOperation operation;

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
        operation = SyncQueueOperation.insert;
      } else {
        await (_database.update(
          _database.threadPurchases,
        )..where((table) => table.id.equals(purchaseId))).write(
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
        operation = SyncQueueOperation.update;
      }

      await _queueSync(
        operation: operation,
        tableName: 'thread_purchases',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'supplierId': supplierId,
          'itemName': itemName.trim(),
          'colorNumber': colorNumber.trim(),
          'purchaseDate': purchaseDate.toIso8601String(),
          'price': price,
          'quantity': quantity,
          'unit': unit.trim(),
          'notes': notes,
        },
      );
    });
  }

  Future<void> deletePurchase(int purchaseId) async {
    await _database.transaction(() async {
      final row = await (_database.select(
        _database.threadPurchases,
      )..where((t) => t.id.equals(purchaseId))).getSingleOrNull();
      if (row == null) {
        return;
      }
      await (_database.delete(
        _database.threadPurchases,
      )..where((t) => t.id.equals(purchaseId))).go();
      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'thread_purchases',
        recordId: purchaseId,
        payload: <String, dynamic>{
          'id': purchaseId,
          'supplierId': row.supplierId,
        },
      );
    });
  }

  Future<void> addPayment({
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.supplierPayments)
          .insert(
            SupplierPaymentsCompanion.insert(
              supplierId: supplierId,
              amount: amount,
              paymentDate: paymentDate,
              notes: Value(notes),
            ),
          );
      await _queueSync(
        operation: SyncQueueOperation.insert,
        tableName: 'supplier_payments',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'supplierId': supplierId,
          'amount': amount,
          'paymentDate': paymentDate.toIso8601String(),
          'notes': notes,
        },
      );
    });
  }

  Future<void> addOrUpdatePayment({
    int? paymentId,
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) async {
    await _database.transaction(() async {
      late final int id;
      late final SyncQueueOperation operation;

      if (paymentId == null) {
        id = await _database
            .into(_database.supplierPayments)
            .insert(
              SupplierPaymentsCompanion.insert(
                supplierId: supplierId,
                amount: amount,
                paymentDate: paymentDate,
                notes: Value(notes),
              ),
            );
        operation = SyncQueueOperation.insert;
      } else {
        await (_database.update(
          _database.supplierPayments,
        )..where((table) => table.id.equals(paymentId))).write(
          SupplierPaymentsCompanion(
            supplierId: Value(supplierId),
            amount: Value(amount),
            paymentDate: Value(paymentDate),
            notes: Value(notes),
          ),
        );
        id = paymentId;
        operation = SyncQueueOperation.update;
      }

      await _queueSync(
        operation: operation,
        tableName: 'supplier_payments',
        recordId: id,
        payload: <String, dynamic>{
          'id': id,
          'supplierId': supplierId,
          'amount': amount,
          'paymentDate': paymentDate.toIso8601String(),
          'notes': notes,
        },
      );
    });
  }

  Future<void> deletePayment(int paymentId) async {
    await _database.transaction(() async {
      final row = await (_database.select(
        _database.supplierPayments,
      )..where((t) => t.id.equals(paymentId))).getSingleOrNull();
      if (row == null) {
        return;
      }
      await (_database.delete(
        _database.supplierPayments,
      )..where((t) => t.id.equals(paymentId))).go();
      await _queueSync(
        operation: SyncQueueOperation.delete,
        tableName: 'supplier_payments',
        recordId: paymentId,
        payload: <String, dynamic>{
          'id': paymentId,
          'supplierId': row.supplierId,
        },
      );
    });
  }

  Stream<List<QueryRow>> _watchTrigger() {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.suppliers,
            _database.threadPurchases,
            _database.supplierPayments,
          },
        )
        .watch();
  }

  Future<List<SupplierListItem>> _buildSupplierList(DateTime month) async {
    final rows = await (_database.select(
      _database.suppliers,
    )..orderBy([(t) => OrderingTerm(expression: t.name)])).get();
    final result = <SupplierListItem>[];
    for (final row in rows) {
      final summary = await _buildSupplierSummary(row.id, month);
      result.add(
        SupplierListItem(
          id: row.id,
          name: row.name,
          totalPurchased: summary.totalPurchased,
          totalPaid: summary.totalPaid,
          outstandingBalance: summary.outstandingBalance,
        ),
      );
    }
    return result;
  }

  Future<SupplierDetailsData> _buildSupplierDetails(
    int supplierId,
    DateTime month,
  ) async {
    final supplierRow = await (_database.select(
      _database.suppliers,
    )..where((t) => t.id.equals(supplierId))).getSingle();
    final summary = await _buildSupplierSummary(supplierId, month);
    final monthRange = _monthRange(month);

    final purchaseRows =
        await (_database.select(_database.threadPurchases)
              ..where(
                (t) =>
                    t.supplierId.equals(supplierId) &
                    t.purchaseDate.isBetweenValues(
                      monthRange.start,
                      monthRange.end,
                    ),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)]))
            .get();
    final paymentRows =
        await (_database.select(_database.supplierPayments)
              ..where(
                (t) =>
                    t.supplierId.equals(supplierId) &
                    t.paymentDate.isBetweenValues(
                      monthRange.start,
                      monthRange.end,
                    ),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]))
            .get();

    return SupplierDetailsData(
      supplier: Supplier(
        id: supplierRow.id,
        name: supplierRow.name,
        phone: supplierRow.phone,
        createdAt: supplierRow.createdAt,
      ),
      summary: summary,
      purchases: purchaseRows
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
          .toList(),
      payments: paymentRows
          .map(
            (row) => SupplierPaymentEntry(
              id: row.id,
              supplierId: row.supplierId,
              amount: row.amount,
              paymentDate: row.paymentDate,
              notes: row.notes,
            ),
          )
          .toList(),
    );
  }

  Future<SupplierSummary> _buildSupplierSummary(
    int supplierId,
    DateTime month,
  ) async {
    final monthRange = _monthRange(month);
    final purchaseRows =
        await (_database.select(_database.threadPurchases)..where(
              (t) =>
                  t.supplierId.equals(supplierId) &
                  t.purchaseDate.isBetweenValues(
                    monthRange.start,
                    monthRange.end,
                  ),
            ))
            .get();
    final paymentRows =
        await (_database.select(_database.supplierPayments)..where(
              (t) =>
                  t.supplierId.equals(supplierId) &
                  t.paymentDate.isBetweenValues(
                    monthRange.start,
                    monthRange.end,
                  ),
            ))
            .get();
    final totalPurchased = purchaseRows.fold<double>(
      0,
      (sum, row) => sum + row.price,
    );
    final totalPaid = paymentRows.fold<double>(
      0,
      (sum, row) => sum + row.amount,
    );
    return SupplierSummary(
      totalPurchased: totalPurchased,
      totalPaid: totalPaid,
      outstandingBalance: totalPurchased - totalPaid,
    );
  }

  Future<ThreadsOverview> _buildOverview(DateTime month) async {
    final monthRange = _monthRange(month);
    final yearStart = DateTime(month.year);
    final yearEnd = DateTime(month.year, 12, 31, 23, 59, 59, 999);
    final supplierIds = (await _database.select(_database.suppliers).get())
        .map((supplier) => supplier.id)
        .toSet();

    final monthPurchases =
        await (_database.select(_database.threadPurchases)..where(
              (t) => t.purchaseDate.isBetweenValues(
                monthRange.start,
                monthRange.end,
              ),
            ))
            .get();
    final yearPurchases = await (_database.select(
      _database.threadPurchases,
    )..where((t) => t.purchaseDate.isBetweenValues(yearStart, yearEnd))).get();
    final yearPayments = await (_database.select(
      _database.supplierPayments,
    )..where((t) => t.paymentDate.isBetweenValues(yearStart, yearEnd))).get();
    final allPurchases = await _database
        .select(_database.threadPurchases)
        .get();
    final allPayments = await _database
        .select(_database.supplierPayments)
        .get();

    final activeMonthPurchases = monthPurchases
        .where((row) => supplierIds.contains(row.supplierId))
        .toList();
    final activeYearPurchases = yearPurchases
        .where((row) => supplierIds.contains(row.supplierId))
        .toList();
    final activeYearPayments = yearPayments
        .where((row) => supplierIds.contains(row.supplierId))
        .toList();
    final activeAllPurchases = allPurchases
        .where((row) => supplierIds.contains(row.supplierId))
        .toList();
    final activeAllPayments = allPayments
        .where((row) => supplierIds.contains(row.supplierId))
        .toList();

    return ThreadsOverview(
      monthlyPurchased: activeMonthPurchases.fold<double>(
        0,
        (sum, row) => sum + row.price,
      ),
      yearlyPurchased: activeYearPurchases.fold<double>(
        0,
        (sum, row) => sum + row.price,
      ),
      yearlyPaid: activeYearPayments.fold<double>(
        0,
        (sum, row) => sum + row.amount,
      ),
      totalOutstanding:
          activeAllPurchases.fold<double>(0, (sum, row) => sum + row.price) -
          activeAllPayments.fold<double>(0, (sum, row) => sum + row.amount),
    );
  }

  Future<void> _queueSync({
    required SyncQueueOperation operation,
    required String tableName,
    required int recordId,
    required Map<String, dynamic> payload,
  }) {
    return _database
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

  ({DateTime start, DateTime end}) _monthRange(DateTime month) {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
    return (start: start, end: end);
  }
}
