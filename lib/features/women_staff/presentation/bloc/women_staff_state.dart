import '../../domain/entities/staff_list_item.dart';

class WomenStaffState {
  const WomenStaffState({
    required this.selectedMonth,
    required this.items,
    required this.searchQuery,
    required this.isLoading,
    this.errorMessage,
  });

  factory WomenStaffState.initial() => WomenStaffState(
    selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    items: const <StaffListItem>[],
    searchQuery: '',
    isLoading: true,
  );

  final DateTime selectedMonth;
  final List<StaffListItem> items;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  List<StaffListItem> get filteredItems {
    if (searchQuery.trim().isEmpty) {
      return items;
    }
    final query = searchQuery.trim().toLowerCase();
    return items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  WomenStaffState copyWith({
    DateTime? selectedMonth,
    List<StaffListItem>? items,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WomenStaffState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
