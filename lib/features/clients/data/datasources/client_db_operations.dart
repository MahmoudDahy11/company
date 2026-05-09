import 'dart:async';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' hide Client;
import '../../../../core/sync/sync_queue_table.dart';
import '../../domain/entities/client_list_item.dart';
import 'db_helpers.dart';

class ClientDbOperations {
  ClientDbOperations(this._database);

  final AppDatabase _database;

  Stream<List<ClientListItem>> watchClients(DateTime month) {
    final range = monthRange(month);

    return _database
        .customSelect(
          '''
      SELECT 
        c.id, c.name,
        (SELECT SUM(cm.piece_count * cm.price_per_piece) 
         FROM client_models cm 
         WHERE cm.client_id = c.id AND cm.date BETWEEN ? AND ?) as month_amount,
        (SELECT SUM(cp.amount) 
         FROM client_payments cp 
         WHERE cp.client_id = c.id AND cp.payment_date BETWEEN ? AND ?) as month_paid,
        (SELECT SUM(cm2.piece_count * cm2.price_per_piece) 
         FROM client_models cm2 
         WHERE cm2.client_id = c.id AND cm2.date <= ?) as total_amount_all_time,
        (SELECT SUM(cp2.amount) 
         FROM client_payments cp2 
         WHERE cp2.client_id = c.id AND cp2.payment_date <= ?) as total_paid_all_time
      FROM clients c
      WHERE c.is_active = 1
      ORDER BY c.name ASC
      ''',
          variables: [
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
            Variable.withDateTime(range.start),
            Variable.withDateTime(range.end),
            Variable.withDateTime(range.end),
            Variable.withDateTime(range.end),
          ],
          readsFrom: {
            _database.clients,
            _database.clientModels,
            _database.clientPayments,
          },
        )
        .watch()
        .map((rows) {
          return rows.map((row) {
            final monthAmount = row.read<double?>('month_amount') ?? 0.0;
            final monthPaid = row.read<double?>('month_paid') ?? 0.0;
            final totalAmountAllTime =
                row.read<double?>('total_amount_all_time') ?? 0.0;
            final totalPaidAllTime =
                row.read<double?>('total_paid_all_time') ?? 0.0;

            return ClientListItem(
              id: row.read<int>('id'),
              name: row.read<String>('name'),
              totalAmount: monthAmount,
              totalPaid: monthPaid,
              outstanding: totalAmountAllTime - totalPaidAllTime,
            );
          }).toList();
        });
  }
  Future<void> addClient({required String name, String? phone}) async {
    await _database.transaction(() async {
      final id = await _database
          .into(_database.clients)
          .insert(ClientsCompanion.insert(
            name: name.trim(),
            phone: Value(phone?.trim().isEmpty == true ? null : phone?.trim()),
          ));
      final client = await (_database.select(_database.clients)..where((t) => t.id.equals(id))).getSingle();
      await queueSyncEntry(
        _database,
        operation: SyncQueueOperation.insert,
        tableName: 'clients',
        recordId: id,
        payload: client.toJson(),
      );
    });
  }

  Future<void> deleteClient(int clientId) async {
    final existing = await (_database.select(
      _database.clients,
    )..where((t) => t.id.equals(clientId))).getSingleOrNull();
    if (existing == null) return;

    await _database.transaction(() async {
      await (_database.update(_database.clients)
            ..where((t) => t.id.equals(clientId)))
          .write(const ClientsCompanion(isActive: Value(false)));

      final updated = await (_database.select(
        _database.clients,
      )..where((t) => t.id.equals(clientId))).getSingle();
      await queueSyncEntry(
        _database,
        operation: SyncQueueOperation.update,
        tableName: 'clients',
        recordId: clientId,
        payload: updated.toJson(),
      );
    });
  }
}
