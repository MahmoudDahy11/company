import 'package:drift/drift.dart';

class WomenStaffMembers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  RealColumn get monthlySalary => real()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class StaffAdvances extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get staffId => integer().references(WomenStaffMembers, #id)();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get notes => text().nullable()();

  BoolColumn get carriedOver => boolean().withDefault(const Constant(false))();
}

class StaffDeductions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get staffId => integer().references(WomenStaffMembers, #id)();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get notes => text().nullable()();
}
