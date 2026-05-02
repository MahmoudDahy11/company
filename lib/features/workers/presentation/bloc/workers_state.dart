import '../../domain/entities/worker_list_item.dart';

class WorkersState {
  const WorkersState({
    required this.selectedMonth,
    required this.items,
    required this.searchQuery,
    required this.isLoading,
    this.errorMessage,
  });

  factory WorkersState.initial() => WorkersState(
    selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    items: const <WorkerListItem>[],
    searchQuery: '',
    isLoading: true,
  );

  final DateTime selectedMonth;
  final List<WorkerListItem> items;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  List<WorkerListItem> get filteredItems {
    if (searchQuery.trim().isEmpty) {
      return items;
    }

    final query = searchQuery.trim().toLowerCase();
    return items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  WorkersState copyWith({
    DateTime? selectedMonth,
    List<WorkerListItem>? items,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WorkersState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
