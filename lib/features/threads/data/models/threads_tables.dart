import 'package:drift/drift.dart';

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get phone => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class ThreadPurchases extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get supplierId => integer().references(Suppliers, #id)();

  TextColumn get itemName => text()();

  TextColumn get colorNumber => text()();

  DateTimeColumn get purchaseDate => dateTime()();

  RealColumn get price => real()();

  RealColumn get quantity => real()();

  TextColumn get unit => text()();

  TextColumn get notes => text().nullable()();
}

class SupplierPayments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get supplierId => integer().references(Suppliers, #id)();

  RealColumn get amount => real()();

  DateTimeColumn get paymentDate => dateTime()();

  TextColumn get notes => text().nullable()();
}
