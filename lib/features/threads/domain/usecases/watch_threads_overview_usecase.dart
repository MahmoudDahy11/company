import 'package:injectable/injectable.dart';

import '../entities/threads_overview.dart';
import '../repositories/threads_repository.dart';

@injectable
class WatchThreadsOverviewUseCase {
  const WatchThreadsOverviewUseCase(this._repository);

  final ThreadsRepository _repository;

  Stream<ThreadsOverview> call(DateTime month) =>
      _repository.watchOverview(month);
}
