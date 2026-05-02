import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/staff_details_data.dart';
import '../../domain/usecases/add_staff_advance_usecase.dart';
import '../../domain/usecases/delete_staff_advance_usecase.dart';
import '../../domain/usecases/update_salary_usecase.dart';
import '../../domain/usecases/watch_staff_details_usecase.dart';
import 'staff_details_state.dart';

@injectable
class StaffDetailsCubit extends Cubit<StaffDetailsState> {
  StaffDetailsCubit(
    this._watchStaffDetailsUseCase,
    this._addStaffAdvanceUseCase,
    this._deleteStaffAdvanceUseCase,
    this._updateSalaryUseCase,
  ) : super(StaffDetailsState.initial(0));

  final WatchStaffDetailsUseCase _watchStaffDetailsUseCase;
  final AddStaffAdvanceUseCase _addStaffAdvanceUseCase;
  final DeleteStaffAdvanceUseCase _deleteStaffAdvanceUseCase;
  final UpdateSalaryUseCase _updateSalaryUseCase;

  StreamSubscription<StaffDetailsData>? _subscription;

  void init(int staffId) {
    emit(StaffDetailsState.initial(staffId));
    _subscribe();
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

  Future<void> addAdvance({
    required double amount,
    required DateTime date,
    String? notes,
  }) {
    return _addStaffAdvanceUseCase(
      staffId: state.staffId,
      amount: amount,
      date: date,
      notes: notes,
    );
  }

  Future<void> deleteAdvance(int advanceId) {
    return _deleteStaffAdvanceUseCase(advanceId);
  }

  Future<void> updateSalary(double monthlySalary) {
    return _updateSalaryUseCase(
      staffId: state.staffId,
      monthlySalary: monthlySalary,
    );
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription =
        _watchStaffDetailsUseCase(state.staffId, state.selectedMonth).listen(
          (details) => emit(
            state.copyWith(
              details: details,
              isLoading: false,
              errorMessage: null,
            ),
          ),
          onError: (Object error) => emit(
            state.copyWith(isLoading: false, errorMessage: error.toString()),
          ),
        );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
