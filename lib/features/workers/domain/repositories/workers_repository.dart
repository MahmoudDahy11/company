import '../entities/worker_details_data.dart';
import '../entities/worker_list_item.dart';

abstract class WorkersRepository {
  Stream<List<WorkerListItem>> watchWorkers(DateTime month);

  Stream<WorkerDetailsData> watchWorkerDetails(int workerId, DateTime month);

  Future<void> addWorker(String name);

  Future<void> deleteWorker(int workerId);

  Future<void> addOrUpdateProduction({
    int? productionId,
    required int workerId,
    required DateTime date,
    required int stitchCount,
    String? notes,
  });

  Future<void> deleteProduction(int productionId);

  Future<void> addAdvance({
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  });

  Future<void> addOrUpdateAdvance({
    int? advanceId,
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  });

  Future<void> deleteAdvance(int advanceId);

  Future<void> addDeduction({
    required int workerId,
    required double amount,
    required DateTime date,
    String? notes,
  });

  Future<void> deleteDeduction(int deductionId);

  Future<void> upsertAbsentDays({
    required int workerId,
    required DateTime month,
    required int absentDays,
  });

  Future<void> updateStitchRate({
    required double rate,
    required DateTime effectiveFrom,
  });
}
