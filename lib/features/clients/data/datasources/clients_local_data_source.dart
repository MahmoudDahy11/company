import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/client_details_data.dart';
import '../../domain/entities/client_list_item.dart';
import 'client_db_operations.dart';
import 'client_details_db_operations.dart';
import 'client_model_db_operations.dart';
import 'client_payment_db_operations.dart';

@lazySingleton
class ClientsLocalDataSource {
  ClientsLocalDataSource(AppDatabase database)
    : _clientDb = ClientDbOperations(database),
      _modelDb = ModelDbOperations(database),
      _paymentDb = PaymentDbOperations(database),
      _detailsDb = DetailsDbOperations(database);

  final ClientDbOperations _clientDb;
  final ModelDbOperations _modelDb;
  final PaymentDbOperations _paymentDb;
  final DetailsDbOperations _detailsDb;

  Stream<List<ClientListItem>> watchClients(DateTime month) =>
      _clientDb.watchClients(month);

  Stream<ClientDetailsData> watchClientDetails(int clientId, DateTime month) =>
      _detailsDb.watchClientDetails(clientId, month);

  Future<void> addClient({required String name, String? phone}) =>
      _clientDb.addClient(name: name, phone: phone);

  Future<void> deleteClient(int clientId) => _clientDb.deleteClient(clientId);

  Future<void> addModel({
    required int clientId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) => _modelDb.addModel(
    clientId: clientId,
    modelName: modelName,
    pieceCount: pieceCount,
    pricePerPiece: pricePerPiece,
    date: date,
    notes: notes,
  );

  Future<void> updateModel({
    required int modelId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) => _modelDb.updateModel(
    modelId: modelId,
    modelName: modelName,
    pieceCount: pieceCount,
    pricePerPiece: pricePerPiece,
    date: date,
    notes: notes,
  );

  Future<void> deleteModel(int modelId) => _modelDb.deleteModel(modelId);

  Future<void> addPayment({
    required int clientId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _paymentDb.addPayment(
    clientId: clientId,
    amount: amount,
    paymentDate: paymentDate,
    notes: notes,
  );

  Future<void> updatePayment({
    required int paymentId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _paymentDb.updatePayment(
    paymentId: paymentId,
    amount: amount,
    paymentDate: paymentDate,
    notes: notes,
  );

  Future<void> deletePayment(int paymentId) =>
      _paymentDb.deletePayment(paymentId);
}
