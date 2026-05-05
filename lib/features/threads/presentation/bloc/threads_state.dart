import '../../domain/entities/supplier_list_item.dart';
import '../../domain/entities/thread_purchase.dart';
import '../../domain/entities/threads_overview.dart';

class ThreadsState {
  const ThreadsState({
    required this.selectedMonth,
    required this.items,
    required this.allPurchases,
    required this.overview,
    required this.searchQuery,
    required this.isLoading,
    required this.isRefreshing,
    this.errorMessage,
  });

  factory ThreadsState.initial() => ThreadsState(
    selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    items: const <SupplierListItem>[],
    allPurchases: const <ThreadPurchase>[],
    overview: const ThreadsOverview(
      monthlyPurchased: 0,
      yearlyPurchased: 0,
      yearlyPaid: 0,
      totalOutstanding: 0,
    ),
    searchQuery: '',
    isLoading: true,
    isRefreshing: false,
  );

  final DateTime selectedMonth;
  final List<SupplierListItem> items;
  final List<ThreadPurchase> allPurchases;
  final ThreadsOverview overview;
  final String searchQuery;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  List<SupplierListItem> get filteredItems {
    if (searchQuery.trim().isEmpty) {
      return items;
    }
    final query = searchQuery.trim().toLowerCase();
    return items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  ThreadsState copyWith({
    DateTime? selectedMonth,
    List<SupplierListItem>? items,
    List<ThreadPurchase>? allPurchases,
    ThreadsOverview? overview,
    String? searchQuery,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return ThreadsState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      items: items ?? this.items,
      allPurchases: allPurchases ?? this.allPurchases,
      overview: overview ?? this.overview,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}
