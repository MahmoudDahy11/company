import 'package:injectable/injectable.dart';

import '../entities/supplier_list_item.dart';
import '../repositories/threads_repository.dart';

@injectable
class WatchSuppliersUseCase {
  const WatchSuppliersUseCase(this._repository);

  final ThreadsRepository _repository;

  Stream<List<SupplierListItem>> call(DateTime month) =>
      _repository.watchSuppliers(month);
}
