import 'package:injectable/injectable.dart';

import '../../domain/entities/client_details_data.dart';
import '../../domain/entities/client_list_item.dart';
import '../../domain/repositories/clients_repository.dart';
import '../datasources/clients_local_data_source.dart';

@LazySingleton(as: ClientsRepository)
class ClientsRepositoryImpl implements ClientsRepository {
  ClientsRepositoryImpl(this._localDataSource);

  final ClientsLocalDataSource _localDataSource;

  @override
  Stream<List<ClientListItem>> watchClients(DateTime month) =>
      _localDataSource.watchClients(month);

  @override
  Stream<ClientDetailsData> watchClientDetails(int clientId, DateTime month) =>
      _localDataSource.watchClientDetails(clientId, month);

  @override
  Future<void> addClient({required String name, String? phone}) =>
      _localDataSource.addClient(name: name, phone: phone);

  @override
  Future<void> deleteClient(int clientId) =>
      _localDataSource.deleteClient(clientId);

  @override
  Future<void> addModel({
    required int clientId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) => _localDataSource.addModel(
    clientId: clientId,
    modelName: modelName,
    pieceCount: pieceCount,
    pricePerPiece: pricePerPiece,
    date: date,
    notes: notes,
  );

  @override
  Future<void> deleteModel(int modelId) =>
      _localDataSource.deleteModel(modelId);

  @override
  Future<void> addPayment({
    required int clientId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _localDataSource.addPayment(
    clientId: clientId,
    amount: amount,
    paymentDate: paymentDate,
    notes: notes,
  );

  @override
  Future<void> deletePayment(int paymentId) =>
      _localDataSource.deletePayment(paymentId);
}
