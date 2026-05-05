import '../entities/client_details_data.dart';
import '../entities/client_list_item.dart';

abstract class ClientsRepository {
  Stream<List<ClientListItem>> watchClients(DateTime month);

  Stream<ClientDetailsData> watchClientDetails(int clientId, DateTime month);

  Future<void> addClient({required String name, String? phone});

  Future<void> deleteClient(int clientId);

  Future<void> addModel({
    required int clientId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  });

  Future<void> updateModel({
    required int modelId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  });

  Future<void> deleteModel(int modelId);

  Future<void> addPayment({
    required int clientId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  });

  Future<void> updatePayment({
    required int paymentId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  });

  Future<void> deletePayment(int paymentId);
}
