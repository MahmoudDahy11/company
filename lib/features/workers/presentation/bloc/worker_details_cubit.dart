import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/add_advance_usecase.dart';
import '../../domain/usecases/add_or_update_advance_usecase.dart';
import '../../domain/usecases/add_or_update_production_usecase.dart';
import '../../domain/usecases/delete_advance_usecase.dart';
import '../../domain/usecases/delete_production_usecase.dart';
import '../../domain/usecases/upsert_absent_days_usecase.dart';
import '../../domain/usecases/watch_worker_details_usecase.dart';
import 'worker_details_state.dart';

@injectable
class WorkerDetailsCubit extends Cubit<WorkerDetailsState> {
  WorkerDetailsCubit(
    this._watchWorkerDetailsUseCase,
    this._addOrUpdateProductionUseCase,
    this._deleteProductionUseCase,
    this._addAdvanceUseCase,
    this._addOrUpdateAdvanceUseCase,
    this._deleteAdvanceUseCase,
    this._upsertAbsentDaysUseCase,
  ) : super(WorkerDetailsState.initial(0));

  final WatchWorkerDetailsUseCase _watchWorkerDetailsUseCase;
  final AddOrUpdateProductionUseCase _addOrUpdateProductionUseCase;
  final DeleteProductionUseCase _deleteProductionUseCase;
  final AddAdvanceUseCase _addAdvanceUseCase;
  final AddOrUpdateAdvanceUseCase _addOrUpdateAdvanceUseCase;
  final DeleteAdvanceUseCase _deleteAdvanceUseCase;
  final UpsertAbsentDaysUseCase _upsertAbsentDaysUseCase;

  StreamSubscription<dynamic>? _subscription;

  void init(int workerId) {
    emit(WorkerDetailsState.initial(workerId));
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

  Future<void> saveProduction({
    int? productionId,
    required DateTime date,
    required int stitchCount,
    String? notes,
  }) {
    return _addOrUpdateProductionUseCase(
      productionId: productionId,
      workerId: state.workerId,
      date: date,
      stitchCount: stitchCount,
      notes: notes,
    );
  }

  Future<void> deleteProduction(int productionId) {
    return _deleteProductionUseCase(productionId);
  }

  Future<void> addAdvance({
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _addAdvanceUseCase(
      workerId: state.workerId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }

  Future<void> saveAdvance({
    int? advanceId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _addOrUpdateAdvanceUseCase(
      advanceId: advanceId,
      workerId: state.workerId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }

  Future<void> deleteAdvance(int advanceId) {
    return _deleteAdvanceUseCase(advanceId);
  }

  Future<void> saveAbsentDays(int absentDays) {
    return _upsertAbsentDaysUseCase(
      workerId: state.workerId,
      month: state.selectedMonth,
      absentDays: absentDays,
    );
  }

  void _subscribe({Completer<void>? completer}) {
    _subscription?.cancel();
    _subscription =
        _watchWorkerDetailsUseCase(state.workerId, state.selectedMonth).listen(
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
