import 'dart:async';

import 'package:injectable/injectable.dart';

import '../database/app_database.dart';
import 'connectivity_service.dart';
import 'sync_queue_table.dart';
import 'sync_remote_data_source.dart';
import 'sync_status_cubit.dart';

@lazySingleton
class SyncService {
  SyncService(
    this._database,
    this._connectivityService,
    this._remoteDataSource,
    this._syncStatusCubit,
  );

  final AppDatabase _database;
  final ConnectivityService _connectivityService;
  final SyncRemoteDataSource _remoteDataSource;
  final SyncStatusCubit _syncStatusCubit;

  StreamSubscription<bool>? _connectivitySubscription;
  bool _isProcessing = false;

  Future<void> start() async {
    _syncStatusCubit.start();
    _connectivitySubscription ??= _connectivityService.watchConnection().listen(
      (isConnected) async {
        if (isConnected) {
          await processQueue();
        }
      },
    );

    if (await _connectivityService.isConnected()) {
      await processQueue();
    }
  }

  Future<void> processQueue() async {
    if (_isProcessing) {
      return;
    }

    _isProcessing = true;
    _syncStatusCubit.setSyncing(true);

    try {
      final entries = await _database.getPendingSyncEntries();
      for (final entry in entries) {
        await _syncEntry(entry);
      }
    } finally {
      _isProcessing = false;
      _syncStatusCubit.setSyncing(false);
    }
  }

  Future<void> _syncEntry(SyncQueueData entry) async {
    try {
      await _remoteDataSource.pushEntry(entry);
      await _database.markSyncEntryStatus(
        id: entry.id,
        status: SyncQueueStatus.synced,
      );
    } catch (_) {
      final nextRetryCount = entry.retryCount + 1;
      await _database.markSyncEntryStatus(
        id: entry.id,
        status: nextRetryCount >= 3
            ? SyncQueueStatus.failed
            : SyncQueueStatus.pending,
        retryCount: nextRetryCount,
      );
    }
  }

  Future<List<SyncQueueData>> getPendingOrFailedEntries() {
    return _database.getPendingOrFailedSyncEntries();
  }

  Future<void> clearQueue() {
    return _database.clearSyncQueue();
  }

  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
  }
}
