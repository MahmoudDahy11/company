import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/add_worker_usecase.dart';
import '../../domain/usecases/delete_worker_usecase.dart';
import '../../domain/usecases/update_stitch_rate_usecase.dart';
import '../../domain/usecases/watch_workers_usecase.dart';
import 'workers_state.dart';

@injectable
class WorkersCubit extends Cubit<WorkersState> {
  WorkersCubit(
    this._watchWorkersUseCase,
    this._addWorkerUseCase,
    this._deleteWorkerUseCase,
    this._updateStitchRateUseCase,
  ) : super(WorkersState.initial());

  final WatchWorkersUseCase _watchWorkersUseCase;
  final AddWorkerUseCase _addWorkerUseCase;
  final DeleteWorkerUseCase _deleteWorkerUseCase;
  final UpdateStitchRateUseCase _updateStitchRateUseCase;

  StreamSubscription<List<dynamic>>? _subscription;

  void start() {
    _subscription?.cancel();
    emit(state.copyWith(isLoading: true, errorMessage: null));
    _subscription = _watchWorkersUseCase(state.selectedMonth).listen(
      (items) {
        emit(
          state.copyWith(items: items, isLoading: false, errorMessage: null),
        );
      },
      onError: (Object error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
      },
    );
  }

  Future<void> addWorker(String name) async {
    await _addWorkerUseCase(name);
  }

  Future<void> deleteWorker(int workerId) async {
    await _deleteWorkerUseCase(workerId);
  }

  Future<void> updateStitchRate(double rate) async {
    await _updateStitchRateUseCase(rate: rate, effectiveFrom: DateTime.now());
  }

  void updateSearchQuery(String value) {
    emit(state.copyWith(searchQuery: value));
  }

  void previousMonth() {
    emit(
      state.copyWith(
        selectedMonth: DateTime(
          state.selectedMonth.year,
          state.selectedMonth.month - 1,
        ),
      ),
    );
    start();
  }

  void nextMonth() {
    emit(
      state.copyWith(
        selectedMonth: DateTime(
          state.selectedMonth.year,
          state.selectedMonth.month + 1,
        ),
      ),
    );
    start();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
