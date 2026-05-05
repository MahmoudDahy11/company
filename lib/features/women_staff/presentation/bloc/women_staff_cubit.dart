import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/sync/sync_service.dart';
import '../../domain/entities/staff_list_item.dart';
import '../../domain/usecases/add_staff_advance_usecase.dart';
import '../../domain/usecases/add_staff_deduction_usecase.dart';
import '../../domain/usecases/add_staff_usecase.dart';
import '../../domain/usecases/delete_staff_usecase.dart';
import '../../domain/usecases/watch_staff_usecase.dart';
import 'women_staff_state.dart';

@injectable
class WomenStaffCubit extends Cubit<WomenStaffState> {
  WomenStaffCubit(
    this._watchStaffUseCase,
    this._addStaffUseCase,
    this._deleteStaffUseCase,
    this._addStaffAdvanceUseCase,
    this._addStaffDeductionUseCase,
  ) : super(WomenStaffState.initial());

  final WatchStaffUseCase _watchStaffUseCase;
  final AddStaffUseCase _addStaffUseCase;
  final DeleteStaffUseCase _deleteStaffUseCase;
  final AddStaffAdvanceUseCase _addStaffAdvanceUseCase;
  final AddStaffDeductionUseCase _addStaffDeductionUseCase;

  StreamSubscription<List<StaffListItem>>? _subscription;

  Future<void> start() async {
    _subscription?.cancel();
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // Perform a forced sync from the server
    try {
      await GetIt.I<SyncService>().forceSync();
    } catch (_) {}

    final completer = Completer<void>();
    _subscription = _watchStaffUseCase(state.selectedMonth).listen(
      (items) {
        emit(
          state.copyWith(items: items, isLoading: false, errorMessage: null),
        );
        if (!completer.isCompleted) completer.complete();
      },
      onError: (Object error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
        if (!completer.isCompleted) completer.complete();
      },
    );
    return completer.future;
  }

  Future<void> addStaff({required String name, required double monthlySalary}) {
    return _addStaffUseCase(name: name, monthlySalary: monthlySalary);
  }

  Future<void> deleteStaff(int staffId) {
    return _deleteStaffUseCase(staffId);
  }

  Future<void> addAdvance({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _addStaffAdvanceUseCase(
      staffId: staffId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }

  Future<void> addDeduction({
    required int staffId,
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _addStaffDeductionUseCase(
      staffId: staffId,
      amount: amount,
      date: date,
      notes: notes,
    );
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
