import 'package:injectable/injectable.dart';

import '../entities/supplier_details_data.dart';
import '../repositories/threads_repository.dart';

@injectable
class WatchSupplierDetailsUseCase {
  const WatchSupplierDetailsUseCase(this._repository);

  final ThreadsRepository _repository;

  Stream<SupplierDetailsData> call(int supplierId, DateTime month) =>
      _repository.watchSupplierDetails(supplierId, month);
}
