import '../../domain/entities/client_details_data.dart';

class ClientDetailsState {
  const ClientDetailsState({
    required this.clientId,
    required this.selectedMonth,
    this.details,
    required this.isLoading,
    this.errorMessage,
  });

  factory ClientDetailsState.initial(int clientId) => ClientDetailsState(
    clientId: clientId,
    selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    isLoading: true,
  );

  final int clientId;
  final DateTime selectedMonth;
  final ClientDetailsData? details;
  final bool isLoading;
  final String? errorMessage;

  ClientDetailsState copyWith({
    DateTime? selectedMonth,
    ClientDetailsData? details,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ClientDetailsState(
      clientId: clientId,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      details: details ?? this.details,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
