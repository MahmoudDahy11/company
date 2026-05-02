import 'client.dart';
import 'client_model_entry.dart';
import 'client_payment_entry.dart';
import 'client_summary.dart';

class ClientDetailsData {
  const ClientDetailsData({
    required this.client,
    required this.summary,
    required this.models,
    required this.payments,
  });

  final Client client;
  final ClientSummary summary;
  final List<ClientModelEntry> models;
  final List<ClientPaymentEntry> payments;
}
