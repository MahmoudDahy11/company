import '../../domain/entities/maintenance_fault_record.dart';

class MaintenanceFaultRecordsState {
  const MaintenanceFaultRecordsState({
    required this.items,
    required this.isLoading,
    this.errorMessage,
  });

  factory MaintenanceFaultRecordsState.initial() =>
      const MaintenanceFaultRecordsState(
        items: [],
        isLoading: true,
      );

  final List<MaintenanceFaultRecord> items;
  final bool isLoading;
  final String? errorMessage;

  MaintenanceFaultRecordsState copyWith({
    List<MaintenanceFaultRecord>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MaintenanceFaultRecordsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
