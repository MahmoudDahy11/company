import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/staff_list_item.dart';
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
  ) : super(WomenStaffState.initial());

  final WatchStaffUseCase _watchStaffUseCase;
  final AddStaffUseCase _addStaffUseCase;
  final DeleteStaffUseCase _deleteStaffUseCase;

  StreamSubscription<List<StaffListItem>>? _subscription;

  void start() {
    _subscription?.cancel();
    emit(state.copyWith(isLoading: true, errorMessage: null));
    _subscription = _watchStaffUseCase(state.selectedMonth).listen(
      (items) => emit(
        state.copyWith(items: items, isLoading: false, errorMessage: null),
      ),
      onError: (Object error) => emit(
        state.copyWith(isLoading: false, errorMessage: error.toString()),
      ),
    );
  }

  Future<void> addStaff({required String name, required double monthlySalary}) {
    return _addStaffUseCase(name: name, monthlySalary: monthlySalary);
  }

  Future<void> deleteStaff(int staffId) {
    return _deleteStaffUseCase(staffId);
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
