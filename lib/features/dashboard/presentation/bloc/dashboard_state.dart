import '../../domain/entities/dashboard_summary.dart';

class DashboardState {
  const DashboardState({
    required this.selectedMonth,
    required this.isLoading,
    this.summary,
    this.errorMessage,
  });

  factory DashboardState.initial() => DashboardState(
    selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    isLoading: true,
  );

  final DateTime selectedMonth;
  final bool isLoading;
  final DashboardSummary? summary;
  final String? errorMessage;

  DashboardState copyWith({
    DateTime? selectedMonth,
    bool? isLoading,
    DashboardSummary? summary,
    String? errorMessage,
  }) {
    return DashboardState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      isLoading: isLoading ?? this.isLoading,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }
}
