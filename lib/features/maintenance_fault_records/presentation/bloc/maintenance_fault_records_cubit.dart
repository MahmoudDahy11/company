import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/add_maintenance_fault_record_usecase.dart';
import '../../domain/usecases/delete_maintenance_fault_record_usecase.dart';
import '../../domain/usecases/update_maintenance_fault_record_usecase.dart';
import '../../domain/usecases/watch_maintenance_fault_records_usecase.dart';
import 'maintenance_fault_records_state.dart';

@injectable
class MaintenanceFaultRecordsCubit extends Cubit<MaintenanceFaultRecordsState> {
  MaintenanceFaultRecordsCubit(
    this._watchRecordsUseCase,
    this._addRecordUseCase,
    this._updateRecordUseCase,
    this._deleteRecordUseCase,
  ) : super(MaintenanceFaultRecordsState.initial());

  final WatchMaintenanceFaultRecordsUseCase _watchRecordsUseCase;
  final AddMaintenanceFaultRecordUseCase _addRecordUseCase;
  final UpdateMaintenanceFaultRecordUseCase _updateRecordUseCase;
  final DeleteMaintenanceFaultRecordUseCase _deleteRecordUseCase;

  StreamSubscription<dynamic>? _subscription;

  Future<void> start() async {
    _subscription?.cancel();
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final completer = Completer<void>();
    _subscription = _watchRecordsUseCase().listen(
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

  Future<void> addRecord({
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  }) async {
    await _addRecordUseCase(
      machineName: machineName,
      faultName: faultName,
      cost: cost,
      totalCost: totalCost,
    );
  }

  Future<void> updateRecord({
    required int id,
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
  }) async {
    await _updateRecordUseCase(
      id: id,
      machineName: machineName,
      faultName: faultName,
      cost: cost,
      totalCost: totalCost,
    );
  }

  Future<void> deleteRecord(int id) async {
    await _deleteRecordUseCase(id);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
