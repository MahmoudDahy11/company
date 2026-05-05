import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/sync/sync_service.dart';
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

  Future<void> start() async {
    _subscription?.cancel();

    final isInitialLoad = state.summary == null;
    emit(
      state.copyWith(
        isLoading: isInitialLoad,
        isRefreshing: !isInitialLoad,
        errorMessage: null,
      ),
    );

    try {
      await GetIt.I<SyncService>().forceSync();
    } catch (_) {}

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
                isRefreshing: false,
                errorMessage: null,
              ),
            );
            if (!completer.isCompleted) completer.complete();
          },
          onError: (Object error) {
            emit(
              state.copyWith(
                isLoading: false,
                isRefreshing: false,
                errorMessage: error.toString(),
              ),
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
