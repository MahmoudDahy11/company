import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart'
    hide Supplier, ThreadPurchase;
import '../../domain/entities/supplier_list_item.dart';
import '../../domain/entities/thread_purchase.dart';
import '../../domain/entities/supplier_details_data.dart';
import '../../domain/entities/threads_overview.dart';
import 'overview_queries.dart';
import 'payments_local_data_source.dart';
import 'purchases_local_data_source.dart';
import 'supplier_details_queries.dart';
import 'suppliers_local_data_source.dart';
import 'threads_db_helpers.dart';

@lazySingleton
class ThreadsLocalDataSource {
  ThreadsLocalDataSource(
    this._database,
    this._suppliers,
    this._purchases,
    this._payments,
  );

  final AppDatabase _database;
  final SuppliersLocalDataSource _suppliers;
  final PurchasesLocalDataSource _purchases;
  final PaymentsLocalDataSource _payments;

  Stream<List<SupplierListItem>> watchSuppliers(DateTime month) =>
      _suppliers.watchSuppliers(month);

  Stream<List<ThreadPurchase>> watchAllPurchases(DateTime month) =>
      _purchases.watchAllPurchases(month);

  Stream<SupplierDetailsData> watchSupplierDetails(
    int supplierId,
    DateTime month,
  ) => watchTrigger(_database).asyncMap(
    (_) => buildSupplierDetailsData(
      database: _database,
      supplierId: supplierId,
      month: month,
    ),
  );

  Stream<ThreadsOverview> watchOverview(DateTime month) => watchTrigger(
    _database,
  ).asyncMap((_) => buildThreadsOverview(database: _database, month: month));

  Future<void> addSupplier({required String name, String? phone}) =>
      _suppliers.addSupplier(name: name, phone: phone);

  Future<void> deleteSupplier(int supplierId) =>
      _suppliers.deleteSupplier(supplierId);

  Future<void> addPurchase({
    required int supplierId,
    required String itemName,
    required String colorNumber,
    required DateTime purchaseDate,
    required double price,
    required double quantity,
    required String unit,
    String? notes,
  }) => _purchases.addPurchase(
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
  }) => _purchases.addOrUpdatePurchase(
    purchaseId: purchaseId,
    supplierId: supplierId,
    itemName: itemName,
    colorNumber: colorNumber,
    purchaseDate: purchaseDate,
    price: price,
    quantity: quantity,
    unit: unit,
    notes: notes,
  );

  Future<void> deletePurchase(int purchaseId) =>
      _purchases.deletePurchase(purchaseId);

  Future<void> addPayment({
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _payments.addPayment(
    supplierId: supplierId,
    amount: amount,
    paymentDate: paymentDate,
    notes: notes,
  );

  Future<void> addOrUpdatePayment({
    int? paymentId,
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _payments.addOrUpdatePayment(
    paymentId: paymentId,
    supplierId: supplierId,
    amount: amount,
    paymentDate: paymentDate,
    notes: notes,
  );

  Future<void> deletePayment(int paymentId) =>
      _payments.deletePayment(paymentId);
}
