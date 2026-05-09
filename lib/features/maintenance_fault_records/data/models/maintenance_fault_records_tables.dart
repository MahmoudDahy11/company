import 'package:drift/drift.dart';

class MaintenanceFaultRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get machineName => text()();
  TextColumn get faultName => text()();
  RealColumn get cost => real()();
  RealColumn get totalCost => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
