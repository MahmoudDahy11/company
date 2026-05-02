import 'package:drift/drift.dart';

enum SyncQueueOperation { insert, update, delete }

enum SyncQueueStatus { pending, synced, failed }

class SyncQueue extends Table {
  @override
  String get tableName => 'sync_queue';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get operation => textEnum<SyncQueueOperation>()();

  TextColumn get targetTableName => text().named('table_name')();

  IntColumn get recordId => integer()();

  TextColumn get payload => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get status =>
      textEnum<SyncQueueStatus>().withDefault(const Constant('pending'))();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}
