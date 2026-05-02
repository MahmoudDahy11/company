import '../../domain/entities/staff_details_data.dart';

class StaffDetailsState {
  const StaffDetailsState({
    required this.staffId,
    required this.selectedMonth,
    this.details,
    required this.isLoading,
    this.errorMessage,
  });

  factory StaffDetailsState.initial(int staffId) => StaffDetailsState(
    staffId: staffId,
    selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    isLoading: true,
  );

  final int staffId;
  final DateTime selectedMonth;
  final StaffDetailsData? details;
  final bool isLoading;
  final String? errorMessage;

  StaffDetailsState copyWith({
    DateTime? selectedMonth,
    StaffDetailsData? details,
    bool? isLoading,
    String? errorMessage,
  }) {
    return StaffDetailsState(
      staffId: staffId,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      details: details ?? this.details,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
