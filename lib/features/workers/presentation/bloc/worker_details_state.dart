import '../../domain/entities/worker_details_data.dart';

class WorkerDetailsState {
  const WorkerDetailsState({
    required this.workerId,
    required this.selectedMonth,
    this.details,
    required this.isLoading,
    this.errorMessage,
  });

  factory WorkerDetailsState.initial(int workerId) => WorkerDetailsState(
    workerId: workerId,
    selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    isLoading: true,
  );

  final int workerId;
  final DateTime selectedMonth;
  final WorkerDetailsData? details;
  final bool isLoading;
  final String? errorMessage;

  WorkerDetailsState copyWith({
    DateTime? selectedMonth,
    WorkerDetailsData? details,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WorkerDetailsState(
      workerId: workerId,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      details: details ?? this.details,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
