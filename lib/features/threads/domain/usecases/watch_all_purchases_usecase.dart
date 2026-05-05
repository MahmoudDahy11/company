import 'package:injectable/injectable.dart';
import '../entities/thread_purchase.dart';
import '../repositories/threads_repository.dart';

@injectable
class WatchAllPurchasesUseCase {
  const WatchAllPurchasesUseCase(this._repository);

  final ThreadsRepository _repository;

  Stream<List<ThreadPurchase>> call(DateTime month) =>
      _repository.watchAllPurchases(month);
}
