import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/supplier_list_item.dart';
import '../../domain/entities/threads_overview.dart';
import '../../domain/usecases/add_supplier_usecase.dart';
import '../../domain/usecases/delete_supplier_usecase.dart';
import '../../domain/usecases/watch_suppliers_usecase.dart';
import '../../domain/usecases/watch_threads_overview_usecase.dart';
import 'threads_state.dart';

@injectable
class ThreadsCubit extends Cubit<ThreadsState> {
  ThreadsCubit(
    this._watchSuppliersUseCase,
    this._watchThreadsOverviewUseCase,
    this._addSupplierUseCase,
    this._deleteSupplierUseCase,
  ) : super(ThreadsState.initial());

  final WatchSuppliersUseCase _watchSuppliersUseCase;
  final WatchThreadsOverviewUseCase _watchThreadsOverviewUseCase;
  final AddSupplierUseCase _addSupplierUseCase;
  final DeleteSupplierUseCase _deleteSupplierUseCase;

  StreamSubscription<List<SupplierListItem>>? _suppliersSubscription;
  StreamSubscription<ThreadsOverview>? _overviewSubscription;

  void start() {
    _suppliersSubscription?.cancel();
    _overviewSubscription?.cancel();
    emit(state.copyWith(isLoading: true, errorMessage: null));

    _suppliersSubscription = _watchSuppliersUseCase(state.selectedMonth).listen(
      (items) => emit(
        state.copyWith(items: items, isLoading: false, errorMessage: null),
      ),
      onError: (Object error) => emit(
        state.copyWith(isLoading: false, errorMessage: error.toString()),
      ),
    );

    _overviewSubscription = _watchThreadsOverviewUseCase(
      state.selectedMonth,
    ).listen((overview) => emit(state.copyWith(overview: overview)));
  }

  Future<void> addSupplier({required String name, String? phone}) =>
      _addSupplierUseCase(name: name, phone: phone);

  Future<void> deleteSupplier(int supplierId) =>
      _deleteSupplierUseCase(supplierId);

  void updateSearchQuery(String value) =>
      emit(state.copyWith(searchQuery: value));

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
    await _suppliersSubscription?.cancel();
    await _overviewSubscription?.cancel();
    return super.close();
  }
}
