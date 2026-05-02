import '../entities/supplier_details_data.dart';
import '../entities/supplier_list_item.dart';
import '../entities/threads_overview.dart';

abstract class ThreadsRepository {
  Stream<List<SupplierListItem>> watchSuppliers(DateTime month);

  Stream<SupplierDetailsData> watchSupplierDetails(
    int supplierId,
    DateTime month,
  );

  Stream<ThreadsOverview> watchOverview(DateTime month);

  Future<void> addSupplier({required String name, String? phone});

  Future<void> deleteSupplier(int supplierId);

  Future<void> addPurchase({
    required int supplierId,
    required String itemName,
    required String colorNumber,
    required DateTime purchaseDate,
    required double price,
    required double quantity,
    required String unit,
    String? notes,
  });

  Future<void> deletePurchase(int purchaseId);

  Future<void> addPayment({
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  });

  Future<void> deletePayment(int paymentId);
}
