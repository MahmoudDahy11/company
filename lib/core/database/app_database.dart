import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/workers/data/models/workers_tables.dart';
import '../../features/women_staff/data/models/women_staff_tables.dart';
import '../../features/threads/data/models/threads_tables.dart';
import '../sync/sync_queue_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    SyncQueue,
    Workers,
    WorkerProductionEntries,
    WorkerAdvances,
    StitchRates,
    WorkerAbsentDays,
    WomenStaffMembers,
    StaffAdvances,
    Suppliers,
    ThreadPurchases,
    SupplierPayments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(workers);
        await m.createTable(workerProductionEntries);
        await m.createTable(workerAdvances);
        await m.createTable(stitchRates);
        await m.createTable(workerAbsentDays);
      }
      if (from < 3) {
        await m.createTable(womenStaffMembers);
        await m.createTable(staffAdvances);
      }
      if (from < 4) {
        await m.createTable(suppliers);
        await m.createTable(threadPurchases);
        await m.createTable(supplierPayments);
      }
    },
  );

  Stream<List<SyncQueueData>> watchSyncQueue() {
    return (select(
      syncQueue,
    )..orderBy([(table) => OrderingTerm(expression: table.createdAt)])).watch();
  }

  Future<List<SyncQueueData>> getPendingSyncEntries() {
    return (select(syncQueue)
          ..where(
            (table) =>
                table.status.equalsValue(SyncQueueStatus.pending) |
                ((table.status.equalsValue(SyncQueueStatus.failed)) &
                    table.retryCount.isSmallerThanValue(3)),
          )
          ..orderBy([(table) => OrderingTerm(expression: table.createdAt)]))
        .get();
  }

  Future<List<SyncQueueData>> getPendingOrFailedSyncEntries() {
    return (select(syncQueue)
          ..where(
            (table) =>
                table.status.equalsValue(SyncQueueStatus.pending) |
                table.status.equalsValue(SyncQueueStatus.failed),
          )
          ..orderBy([(table) => OrderingTerm(expression: table.createdAt)]))
        .get();
  }

  Future<void> markSyncEntryStatus({
    required int id,
    required SyncQueueStatus status,
    int? retryCount,
  }) {
    return (update(syncQueue)..where((table) => table.id.equals(id))).write(
      SyncQueueCompanion(
        status: Value(status),
        retryCount: retryCount == null
            ? const Value.absent()
            : Value(retryCount),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'factory_system.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
