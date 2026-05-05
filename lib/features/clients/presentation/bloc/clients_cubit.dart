import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/sync/sync_service.dart';
import '../../domain/entities/client_list_item.dart';
import '../../domain/usecases/add_client_usecase.dart';
import '../../domain/usecases/delete_client_usecase.dart';
import '../../domain/usecases/watch_clients_usecase.dart';
import 'clients_state.dart';

@injectable
class ClientsCubit extends Cubit<ClientsState> {
  ClientsCubit(
    this._watchClientsUseCase,
    this._addClientUseCase,
    this._deleteClientUseCase,
  ) : super(ClientsState.initial());

  final WatchClientsUseCase _watchClientsUseCase;
  final AddClientUseCase _addClientUseCase;
  final DeleteClientUseCase _deleteClientUseCase;

  StreamSubscription<List<ClientListItem>>? _subscription;

  Future<void> start() async {
    _subscription?.cancel();
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // Perform a forced sync from the server
    try {
      await GetIt.I<SyncService>().forceSync();
    } catch (_) {
      // Ignore sync errors here, we still want to show local data
    }

    final completer = Completer<void>();
    _subscription = _watchClientsUseCase(state.selectedMonth).listen(
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

  Future<void> addClient({required String name, String? phone}) =>
      _addClientUseCase(name: name, phone: phone);

  Future<void> deleteClient(int clientId) => _deleteClientUseCase(clientId);

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
    await _subscription?.cancel();
    return super.close();
  }
}
