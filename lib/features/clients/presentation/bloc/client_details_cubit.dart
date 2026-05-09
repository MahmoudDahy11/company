import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/sync/sync_service.dart';
import '../../domain/entities/client_details_data.dart';
import '../../domain/usecases/add_client_model_usecase.dart';
import '../../domain/usecases/add_client_payment_usecase.dart';
import '../../domain/usecases/delete_client_model_usecase.dart';
import '../../domain/usecases/delete_client_payment_usecase.dart';
import '../../domain/usecases/update_client_model_usecase.dart';
import '../../domain/usecases/update_client_payment_usecase.dart';
import '../../domain/usecases/watch_client_details_usecase.dart';
import 'client_details_state.dart';

@injectable
class ClientDetailsCubit extends Cubit<ClientDetailsState> {
  ClientDetailsCubit(
    this._watchClientDetailsUseCase,
    this._addClientModelUseCase,
    this._updateClientModelUseCase,
    this._deleteClientModelUseCase,
    this._addClientPaymentUseCase,
    this._updateClientPaymentUseCase,
    this._deleteClientPaymentUseCase,
  ) : super(ClientDetailsState.initial(0));

  final WatchClientDetailsUseCase _watchClientDetailsUseCase;
  final AddClientModelUseCase _addClientModelUseCase;
  final UpdateClientModelUseCase _updateClientModelUseCase;
  final DeleteClientModelUseCase _deleteClientModelUseCase;
  final AddClientPaymentUseCase _addClientPaymentUseCase;
  final UpdateClientPaymentUseCase _updateClientPaymentUseCase;
  final DeleteClientPaymentUseCase _deleteClientPaymentUseCase;
  StreamSubscription<ClientDetailsData>? _subscription;

  void init(int clientId) {
    emit(ClientDetailsState.initial(clientId));
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

  Future<void> addModel({
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) => _addClientModelUseCase(
    clientId: state.clientId,
    modelName: modelName,
    pieceCount: pieceCount,
    pricePerPiece: pieceCount > 0 ? pricePerPiece : 0,
    date: date,
    notes: notes,
  );

  Future<void> updateModel({
    required int modelId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    String? notes,
  }) => _updateClientModelUseCase(
    modelId: modelId,
    modelName: modelName,
    pieceCount: pieceCount,
    pricePerPiece: pieceCount > 0 ? pricePerPiece : 0,
    date: date,
    notes: notes,
  );

  Future<void> deleteModel(int modelId) => _deleteClientModelUseCase(modelId);

  Future<void> addPayment({
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _addClientPaymentUseCase(
    clientId: state.clientId,
    amount: amount,
    paymentDate: paymentDate,
    notes: notes,
  );

  Future<void> updatePayment({
    required int paymentId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) => _updateClientPaymentUseCase(
    paymentId: paymentId,
    amount: amount,
    paymentDate: paymentDate,
    notes: notes,
  );

  Future<void> deletePayment(int paymentId) =>
      _deleteClientPaymentUseCase(paymentId);

  void _subscribe({Completer<void>? completer}) {
    _subscription?.cancel();
    _subscription =
        _watchClientDetailsUseCase(state.clientId, state.selectedMonth).listen(
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
