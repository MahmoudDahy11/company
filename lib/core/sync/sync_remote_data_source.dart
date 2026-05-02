import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../database/app_database.dart';
import 'sync_queue_table.dart';

@lazySingleton
class SyncRemoteDataSource {
  SyncRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> pushEntry(SyncQueueData entry) async {
    final document = _firestore
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
}
