import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/financial_filter.dart';

class DashboardState {
  const DashboardState({
    required this.selectedMonth,
    required this.financialFilter,
    required this.isLoading,
    this.isRefreshing = false,
    this.summary,
    this.errorMessage,
  });

  factory DashboardState.initial() => DashboardState(
    selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    financialFilter: FinancialFilter.lastYear,
    isLoading: true,
  );

  final DateTime selectedMonth;
  final FinancialFilter financialFilter;
  final bool isLoading;
  final bool isRefreshing;
  final DashboardSummary? summary;
  final String? errorMessage;

  DashboardState copyWith({
    DateTime? selectedMonth,
    FinancialFilter? financialFilter,
    bool? isLoading,
    bool? isRefreshing,
    DashboardSummary? summary,
    String? errorMessage,
  }) {
    return DashboardState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      financialFilter: financialFilter ?? this.financialFilter,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }
}
