import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../database/app_database.dart';
import 'sync_queue_table.dart';

enum SyncIndicatorState { synced, syncing, pending, failed }

class SyncStatusState {
  const SyncStatusState({
    required this.indicatorState,
    required this.pendingCount,
    required this.failedCount,
    required this.entries,
  });

  const SyncStatusState.initial()
    : indicatorState = SyncIndicatorState.synced,
      pendingCount = 0,
      failedCount = 0,
      entries = const <SyncQueueData>[];

  final SyncIndicatorState indicatorState;
  final int pendingCount;
  final int failedCount;
  final List<SyncQueueData> entries;

  SyncStatusState copyWith({
    SyncIndicatorState? indicatorState,
    int? pendingCount,
    int? failedCount,
    List<SyncQueueData>? entries,
  }) {
    return SyncStatusState(
      indicatorState: indicatorState ?? this.indicatorState,
      pendingCount: pendingCount ?? this.pendingCount,
      failedCount: failedCount ?? this.failedCount,
      entries: entries ?? this.entries,
    );
  }
}

@lazySingleton
class SyncStatusCubit extends Cubit<SyncStatusState> {
  SyncStatusCubit(this._database) : super(const SyncStatusState.initial());

  final AppDatabase _database;
  StreamSubscription<List<SyncQueueData>>? _subscription;
  bool _isSyncing = false;

  void start() {
    _subscription ??= _database.watchSyncQueue().listen(_emitFromEntries);
  }

  void setSyncing(bool isSyncing) {
    _isSyncing = isSyncing;
    _emitFromEntries(state.entries);
  }

  void _emitFromEntries(List<SyncQueueData> entries) {
    final pendingCount = entries
        .where((entry) => entry.status == SyncQueueStatus.pending)
        .length;
    final failedCount = entries
        .where((entry) => entry.status == SyncQueueStatus.failed)
        .length;

    final indicatorState = _isSyncing
        ? SyncIndicatorState.syncing
        : failedCount > 0
        ? SyncIndicatorState.failed
        : pendingCount > 0
        ? SyncIndicatorState.pending
        : SyncIndicatorState.synced;

    emit(
      state.copyWith(
        indicatorState: indicatorState,
        pendingCount: pendingCount,
        failedCount: failedCount,
        entries: entries,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
