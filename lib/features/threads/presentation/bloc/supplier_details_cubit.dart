import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/supplier_details_data.dart';
import '../../domain/usecases/add_purchase_usecase.dart';
import '../../domain/usecases/add_supplier_payment_usecase.dart';
import '../../domain/usecases/delete_purchase_usecase.dart';
import '../../domain/usecases/delete_supplier_payment_usecase.dart';
import '../../domain/usecases/watch_supplier_details_usecase.dart';
import 'supplier_details_state.dart';

@injectable
class SupplierDetailsCubit extends Cubit<SupplierDetailsState> {
  SupplierDetailsCubit(
    this._watchSupplierDetailsUseCase,
    this._addPurchaseUseCase,
    this._deletePurchaseUseCase,
    this._addSupplierPaymentUseCase,
    this._deleteSupplierPaymentUseCase,
  ) : super(SupplierDetailsState.initial(0));

  final WatchSupplierDetailsUseCase _watchSupplierDetailsUseCase;
  final AddPurchaseUseCase _addPurchaseUseCase;
  final DeletePurchaseUseCase _deletePurchaseUseCase;
  final AddSupplierPaymentUseCase _addSupplierPaymentUseCase;
  final DeleteSupplierPaymentUseCase _deleteSupplierPaymentUseCase;

  StreamSubscription<SupplierDetailsData>? _subscription;

  void init(int supplierId) {
    emit(SupplierDetailsState.initial(supplierId));
    _subscribe();
  }

  Future<void> refresh() {
    final completer = Completer<void>();
    _subscribe(completer: completer);
    return completer.future;
  }

  void previousMonth() {
    emit(
      state.copyWith(
        selectedMonth: DateTime(
          state.selectedMonth.year,
          state.selectedMonth.month - 1,
        ),
        isLoading: true,
      ),
    );
    _subscribe();
  }

  void nextMonth() {
    emit(
      state.copyWith(
        selectedMonth: DateTime(
          state.selectedMonth.year,
          state.selectedMonth.month + 1,
        ),
        isLoading: true,
      ),
    );
    _subscribe();
  }

  Future<void> addPurchase({
    required String itemName,
    required String colorNumber,
    required DateTime purchaseDate,
    required double price,
    required double quantity,
    required String unit,
    String? notes,
  }) => _addPurchaseUseCase(
    supplierId: state.supplierId,
    itemName: itemName,
    colorNumber: colorNumber,
    purchaseDate: purchaseDate,
    price: price,
    quantity: quantity,
    unit: unit,
    notes: notes,
  );

  Future<void> deletePurchase(int purchaseId) =>
      _deletePurchaseUseCase(purchaseId);

  Future<void> addPayment({
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _addSupplierPaymentUseCase(
    supplierId: state.supplierId,
    amount: amount,
    paymentDate: paymentDate,
    notes: notes,
  );

  Future<void> deletePayment(int paymentId) =>
      _deleteSupplierPaymentUseCase(paymentId);

  void _subscribe({Completer<void>? completer}) {
    _subscription?.cancel();
    _subscription =
        _watchSupplierDetailsUseCase(
          state.supplierId,
          state.selectedMonth,
        ).listen(
          (details) {
            emit(
              state.copyWith(
                details: details,
                isLoading: false,
                errorMessage: null,
              ),
            );
            if (completer != null && !completer.isCompleted) {
              completer.complete();
            }
          },
          onError: (Object error) {
            emit(
              state.copyWith(isLoading: false, errorMessage: error.toString()),
            );
            if (completer != null && !completer.isCompleted) {
              completer.complete();
            }
          },
        );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
