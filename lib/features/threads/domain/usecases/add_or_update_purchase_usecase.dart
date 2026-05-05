import 'package:injectable/injectable.dart';

import '../repositories/threads_repository.dart';

@injectable
class AddOrUpdatePurchaseUseCase {
  const AddOrUpdatePurchaseUseCase(this._repository);

  final ThreadsRepository _repository;

  Future<void> call({
    int? purchaseId,
    required int supplierId,
    required String itemName,
    required String colorNumber,
    required DateTime purchaseDate,
    required double price,
    required double quantity,
    required String unit,
    String? notes,
  }) {
    if (price <= 0) throw ArgumentError('Price must be greater than 0');
    if (quantity <= 0) throw ArgumentError('Quantity must be greater than 0');

    return _repository.addOrUpdatePurchase(
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
  }
}
