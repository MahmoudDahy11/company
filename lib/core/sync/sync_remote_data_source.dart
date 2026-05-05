import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../database/app_database.dart';
import '../firebase/firebase_provider.dart';
import 'sync_queue_table.dart';

class RemoteChangeEvent {
  RemoteChangeEvent({
    required this.tableName,
    required this.recordId,
    required this.operation,
    required this.payload,
    required this.timestamp,
  });

  final String tableName;
  final int recordId;
  final SyncQueueOperation operation;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
}

@lazySingleton
class SyncRemoteDataSource {
  SyncRemoteDataSource(this._firebaseProvider);

  final FirebaseProvider _firebaseProvider;
  final Map<String, StreamSubscription<QuerySnapshot>> _listeners = {};

  Future<void> pushEntry(SyncQueueData entry) async {
    final firestore = _firebaseProvider.firestore;
    if (firestore == null) {
      throw Exception('Firestore is not supported on this platform.');
    }

    final document = firestore
        .collection('factory_backup')
        .doc(entry.targetTableName)
        .collection('records')
        .doc(entry.recordId.toString());

    if (entry.operation == SyncQueueOperation.delete) {
      await document.delete();
      return;
    }

    final decodedPayload = jsonDecode(entry.payload);

    await document.set({
      'tableName': entry.targetTableName,
      'recordId': entry.recordId,
      'operation': entry.operation.name.toUpperCase(),
      'payload': decodedPayload is Map<String, dynamic>
          ? decodedPayload
          : <String, dynamic>{'value': decodedPayload},
      'createdAt': Timestamp.fromDate(entry.createdAt),
      'syncedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Stream all remote changes from Firestore for real-time sync
  Stream<RemoteChangeEvent> watchRemoteChanges(List<String> tableNames) async* {
    final firestore = _firebaseProvider.firestore;
    if (firestore == null) {
      throw Exception('Firestore is not supported on this platform.');
    }

    final streamController = StreamController<RemoteChangeEvent>.broadcast();

    try {
      for (final tableName in tableNames) {
        // Cancel existing listener if it exists
        await _listeners[tableName]?.cancel();

        // Listen to all records in this table
        final subscription = firestore
            .collection('factory_backup')
            .doc(tableName)
            .collection('records')
            .orderBy('syncedAt', descending: true)
            .snapshots()
            .listen(
              (snapshot) {
                for (final change in snapshot.docChanges) {
                  final data = change.doc.data();
                  if (data == null) continue;

                  try {
                    final operation = _parseOperation(
                      data['operation'] as String?,
                    );
                    final recordId = data['recordId'] as int?;
                    final payload = data['payload'] as Map<String, dynamic>?;
                    final timestamp =
                        (data['syncedAt'] as Timestamp?)?.toDate() ??
                        DateTime.now();

                    if (recordId != null &&
                        payload != null &&
                        operation != null) {
                      streamController.add(
                        RemoteChangeEvent(
                          tableName: tableName,
                          recordId: recordId,
                          operation: operation,
                          payload: payload,
                          timestamp: timestamp,
                        ),
                      );
                    }
                  } catch (e) {
                    // Skip malformed documents
                  }
                }
              },
              onError: (e) {
                streamController.addError(e);
              },
            );

        _listeners[tableName] = subscription;
      }

      yield* streamController.stream;
    } finally {
      await streamController.close();
    }
  }

  SyncQueueOperation? _parseOperation(String? operation) {
    if (operation == null) return null;
    return switch (operation.toUpperCase()) {
      'INSERT' => SyncQueueOperation.insert,
      'UPDATE' => SyncQueueOperation.update,
      'DELETE' => SyncQueueOperation.delete,
      _ => null,
    };
  }

  /// Dispose all listeners
  Future<void> dispose() async {
    for (final subscription in _listeners.values) {
      await subscription.cancel();
    }
    _listeners.clear();
  }
}
