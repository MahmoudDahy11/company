import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/watch_dashboard_summary_usecase.dart';
import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._watchDashboardSummaryUseCase)
    : super(DashboardState.initial());

  final WatchDashboardSummaryUseCase _watchDashboardSummaryUseCase;
  StreamSubscription<DashboardSummary>? _subscription;

  void start() {
    _subscription?.cancel();
    emit(state.copyWith(isLoading: true, errorMessage: null));
    _subscription = _watchDashboardSummaryUseCase(state.selectedMonth).listen(
      (summary) => emit(
        state.copyWith(summary: summary, isLoading: false, errorMessage: null),
      ),
      onError: (Object error) => emit(
        state.copyWith(isLoading: false, errorMessage: error.toString()),
      ),
    );
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
