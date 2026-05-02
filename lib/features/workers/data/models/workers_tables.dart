import 'package:drift/drift.dart';

class Workers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class WorkerProductionEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workerId => integer().references(Workers, #id)();

  DateTimeColumn get date => dateTime()();

  IntColumn get stitchCount => integer()();

  TextColumn get notes => text().nullable()();
}

class WorkerAdvances extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workerId => integer().references(Workers, #id)();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get notes => text().nullable()();

  BoolColumn get carriedOver => boolean().withDefault(const Constant(false))();
}

class StitchRates extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get rate => real()();

  DateTimeColumn get effectiveFrom => dateTime()();
}

class WorkerAbsentDays extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workerId => integer().references(Workers, #id)();

  DateTimeColumn get monthStart => dateTime()();

  IntColumn get absentDays => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {workerId, monthStart},
  ];
}
