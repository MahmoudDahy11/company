import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/sync/sync_service.dart';
import '../../domain/entities/supplier_details_data.dart';
import '../../domain/usecases/add_or_update_purchase_usecase.dart';
import '../../domain/usecases/add_or_update_supplier_payment_usecase.dart';
import '../../domain/usecases/delete_purchase_usecase.dart';
import '../../domain/usecases/delete_supplier_payment_usecase.dart';
import '../../domain/usecases/watch_supplier_details_usecase.dart';
import 'supplier_details_state.dart';

@injectable
class SupplierDetailsCubit extends Cubit<SupplierDetailsState> {
  SupplierDetailsCubit(
    this._watchSupplierDetailsUseCase,
    this._addOrUpdatePurchaseUseCase,
    this._deletePurchaseUseCase,
    this._addOrUpdateSupplierPaymentUseCase,
    this._deleteSupplierPaymentUseCase,
  ) : super(SupplierDetailsState.initial(0));

  final WatchSupplierDetailsUseCase _watchSupplierDetailsUseCase;
  final AddOrUpdatePurchaseUseCase _addOrUpdatePurchaseUseCase;
  final DeletePurchaseUseCase _deletePurchaseUseCase;
  final AddOrUpdateSupplierPaymentUseCase _addOrUpdateSupplierPaymentUseCase;
  final DeleteSupplierPaymentUseCase _deleteSupplierPaymentUseCase;

  StreamSubscription<SupplierDetailsData>? _subscription;

  void init(int supplierId) {
    emit(SupplierDetailsState.initial(supplierId));
    _subscribe();
  }

  Future<void> refresh() async {
    try {
      await GetIt.I<SyncService>().forceSync();
    } catch (_) {}
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

  Future<void> savePurchase({
    int? purchaseId,
    required String itemName,
    required String colorNumber,
    required DateTime purchaseDate,
    required double price,
    required double quantity,
    required String unit,
    String? notes,
  }) => _addOrUpdatePurchaseUseCase(
    purchaseId: purchaseId,
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

  Future<void> savePayment({
    int? paymentId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _addOrUpdateSupplierPaymentUseCase(
    paymentId: paymentId,
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
