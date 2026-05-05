import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/financial_filter.dart';
import '../../domain/usecases/watch_dashboard_summary_usecase.dart';
import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._watchDashboardSummaryUseCase)
    : super(DashboardState.initial());

  final WatchDashboardSummaryUseCase _watchDashboardSummaryUseCase;
  StreamSubscription<DashboardSummary>? _subscription;

  Future<void> start() {
    _subscription?.cancel();
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final completer = Completer<void>();
    _subscription =
        _watchDashboardSummaryUseCase(
          state.selectedMonth,
          state.financialFilter,
        ).listen(
          (summary) {
            emit(
              state.copyWith(
                summary: summary,
                isLoading: false,
                errorMessage: null,
              ),
            );
            if (!completer.isCompleted) completer.complete();
          },
          onError: (Object error) {
            emit(
              state.copyWith(isLoading: false, errorMessage: error.toString()),
            );
            if (!completer.isCompleted) completer.complete();
          },
        );
    return completer.future;
  }

  void previousMonth() {
    updateMonth(
      DateTime(state.selectedMonth.year, state.selectedMonth.month - 1),
    );
  }

  void nextMonth() {
    updateMonth(
      DateTime(state.selectedMonth.year, state.selectedMonth.month + 1),
    );
  }

  void updateMonth(DateTime newMonth) {
    emit(state.copyWith(selectedMonth: newMonth));
    start();
  }

  void updateFinancialFilter(FinancialFilter filter) {
    emit(state.copyWith(financialFilter: filter));
    start();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
