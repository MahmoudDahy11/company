import 'package:injectable/injectable.dart';

import '../../domain/entities/supplier_details_data.dart';
import '../../domain/entities/supplier_list_item.dart';
import '../../domain/entities/threads_overview.dart';
import '../../domain/repositories/threads_repository.dart';
import '../datasources/threads_local_data_source.dart';

@LazySingleton(as: ThreadsRepository)
class ThreadsRepositoryImpl implements ThreadsRepository {
  ThreadsRepositoryImpl(this._localDataSource);

  final ThreadsLocalDataSource _localDataSource;

  @override
  Stream<List<SupplierListItem>> watchSuppliers(DateTime month) =>
      _localDataSource.watchSuppliers(month);

  @override
  Stream<SupplierDetailsData> watchSupplierDetails(
    int supplierId,
    DateTime month,
  ) => _localDataSource.watchSupplierDetails(supplierId, month);

  @override
  Stream<ThreadsOverview> watchOverview(DateTime month) =>
      _localDataSource.watchOverview(month);

  @override
  Future<void> addSupplier({required String name, String? phone}) =>
      _localDataSource.addSupplier(name: name, phone: phone);

  @override
  Future<void> deleteSupplier(int supplierId) =>
      _localDataSource.deleteSupplier(supplierId);

  @override
  Future<void> addPurchase({
    required int supplierId,
    required String itemName,
    required String colorNumber,
    required DateTime purchaseDate,
    required double price,
    required double quantity,
    required String unit,
    String? notes,
  }) => _localDataSource.addPurchase(
    supplierId: supplierId,
    itemName: itemName,
    colorNumber: colorNumber,
    purchaseDate: purchaseDate,
    price: price,
    quantity: quantity,
    unit: unit,
    notes: notes,
  );

  @override
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
  }) => _localDataSource.addOrUpdatePurchase(
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

  @override
  Future<void> deletePurchase(int purchaseId) =>
      _localDataSource.deletePurchase(purchaseId);

  @override
  Future<void> addPayment({
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _localDataSource.addPayment(
    supplierId: supplierId,
    amount: amount,
    paymentDate: paymentDate,
    notes: notes,
  );

  @override
  Future<void> addOrUpdatePayment({
    int? paymentId,
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _localDataSource.addOrUpdatePayment(
    paymentId: paymentId,
    supplierId: supplierId,
    amount: amount,
    paymentDate: paymentDate,
    notes: notes,
  );

  @override
  Future<void> deletePayment(int paymentId) =>
      _localDataSource.deletePayment(paymentId);
}
