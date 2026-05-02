import '../../domain/entities/client_list_item.dart';

class ClientsState {
  const ClientsState({
    required this.selectedMonth,
    required this.items,
    required this.searchQuery,
    required this.isLoading,
    this.errorMessage,
  });

  factory ClientsState.initial() => ClientsState(
    selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    items: const <ClientListItem>[],
    searchQuery: '',
    isLoading: true,
  );

  final DateTime selectedMonth;
  final List<ClientListItem> items;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  List<ClientListItem> get filteredItems {
    if (searchQuery.trim().isEmpty) {
      return items;
    }
    final query = searchQuery.trim().toLowerCase();
    return items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  ClientsState copyWith({
    DateTime? selectedMonth,
    List<ClientListItem>? items,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ClientsState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
