import 'package:drift/drift.dart';

class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get phone => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class ClientModels extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get clientId => integer().references(Clients, #id)();

  TextColumn get modelName => text()();

  IntColumn get pieceCount => integer()();

  RealColumn get pricePerPiece => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get notes => text().nullable()();
}

class ClientPayments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get clientId => integer().references(Clients, #id)();

  RealColumn get amount => real()();

  DateTimeColumn get paymentDate => dateTime()();

  TextColumn get notes => text().nullable()();
}
