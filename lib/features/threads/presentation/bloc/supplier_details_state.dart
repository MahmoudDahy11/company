import '../../domain/entities/supplier_details_data.dart';

class SupplierDetailsState {
  const SupplierDetailsState({
    required this.supplierId,
    required this.selectedMonth,
    this.details,
    required this.isLoading,
    this.errorMessage,
  });

  factory SupplierDetailsState.initial(int supplierId) => SupplierDetailsState(
    supplierId: supplierId,
    selectedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    isLoading: true,
  );

  final int supplierId;
  final DateTime selectedMonth;
  final SupplierDetailsData? details;
  final bool isLoading;
  final String? errorMessage;

  SupplierDetailsState copyWith({
    DateTime? selectedMonth,
    SupplierDetailsData? details,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SupplierDetailsState(
      supplierId: supplierId,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      details: details ?? this.details,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
