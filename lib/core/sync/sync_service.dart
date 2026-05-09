import 'dart:async';

import 'package:injectable/injectable.dart';

import '../database/app_database.dart';
import 'connectivity_service.dart';
import 'remote_sync_applier.dart';
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
    this._remoteSyncApplier,
  );

  final AppDatabase _database;
  final ConnectivityService _connectivityService;
  final SyncRemoteDataSource _remoteDataSource;
  final SyncStatusCubit _syncStatusCubit;
  final RemoteSyncApplier _remoteSyncApplier;

  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<RemoteChangeEvent>? _remoteChangesSubscription;
  bool _isProcessing = false;

  // List of all table names to watch for remote changes
  static const List<String> _allTableNames = [
    'workers',
    'worker_production_entries',
    'worker_advances',
    'worker_deductions',
    'stitch_rates',
    'worker_absent_days',
    'women_staff_members',
    'women_staff',
    'staff_advances',
    'staff_deductions',
    'suppliers',
    'thread_purchases',
    'supplier_payments',
    'clients',
    'client_models',
    'client_payments',
    'maintenance_fault_records',
  ];

  StreamSubscription<List<SyncQueueData>>? _localQueueSubscription;

  Future<void> start() async {
    _syncStatusCubit.start();

    // Listen for local connectivity changes
    _connectivitySubscription ??= _connectivityService.watchConnection().listen(
      (isConnected) async {
        if (isConnected) {
          await processQueue();
          _startRemoteChangesListener();
          _startLocalQueueListener();
        } else {
          await _stopRemoteChangesListener();
          _stopLocalQueueListener();
        }
      },
    );

    if (await _connectivityService.isConnected()) {
      await processQueue();
      _startRemoteChangesListener();
      _startLocalQueueListener();
    }
  }

  void _startLocalQueueListener() {
    _localQueueSubscription?.cancel();
    _localQueueSubscription = _database.watchSyncQueue().listen((entries) {
      if (entries.any(
        (e) =>
            e.status == SyncQueueStatus.pending ||
            (e.status == SyncQueueStatus.failed && e.retryCount < 3),
      )) {
        processQueue();
      }
    });
  }

  void _stopLocalQueueListener() {
    _localQueueSubscription?.cancel();
    _localQueueSubscription = null;
  }

  /// Start listening to remote changes from Firestore
  void _startRemoteChangesListener() {
    _remoteChangesSubscription?.cancel();

    try {
      _remoteChangesSubscription = _remoteDataSource
          .watchRemoteChanges(_allTableNames)
          .listen(
            (change) async {
              // Apply the remote change to local database
              await _remoteSyncApplier.applyRemoteChange(change);
            },
            onError: (e) {
              // Log error but continue
            },
          );
    } catch (e) {
      // Firestore might not be available on some platforms
    }
  }

  /// Stop listening to remote changes
  Future<void> _stopRemoteChangesListener() async {
    await _remoteChangesSubscription?.cancel();
    _remoteChangesSubscription = null;
  }

  Future<void> forceSync() async {
    if (await _connectivityService.isConnected()) {
      await processQueue();
      _startRemoteChangesListener();
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
    await _remoteChangesSubscription?.cancel();
    await _localQueueSubscription?.cancel();
    await _remoteDataSource.dispose();
  }
}
