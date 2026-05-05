import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../database/app_database.dart';
import 'sync_queue_table.dart';
import 'sync_remote_data_source.dart';

/// Applies remote changes from Firestore to the local Drift database
@lazySingleton
class RemoteSyncApplier {
  RemoteSyncApplier(this._database);

  final AppDatabase _database;

  Future<void> applyRemoteChange(RemoteChangeEvent change) async {
    try {
      await _database.transaction(() async {
        switch (change.tableName.toLowerCase()) {
          case 'workers':
            await _applyWorkerChange(change);
          case 'worker_production':
            await _applyWorkerProductionChange(change);
          case 'worker_production_entries':
            await _applyWorkerProductionChange(change);
          case 'worker_advances':
            await _applyWorkerAdvanceChange(change);
          case 'stitch_rate':
            await _applyStitchRateChange(change);
          case 'stitch_rates':
            await _applyStitchRateChange(change);
          case 'worker_absent_days':
            await _applyWorkerAbsentChange(change);
          case 'women_staff_members':
            await _applyWomenStaffChange(change);
          case 'staff_advances':
            await _applyStaffAdvanceChange(change);
          case 'suppliers':
            await _applySupplierChange(change);
          case 'thread_purchases':
            await _applyThreadPurchaseChange(change);
          case 'supplier_payments':
            await _applySupplierPaymentChange(change);
          case 'clients':
            await _applyClientChange(change);
          case 'client_models':
            await _applyClientModelChange(change);
          case 'client_payments':
            await _applyClientPaymentChange(change);
        }
      });
    } catch (e) {
      // Log error but don't throw - we want to continue syncing
    }
  }

  Future<void> _applyWorkerChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.update(_database.workers)
            ..where((t) => t.id.equals(change.recordId)))
          .write(const WorkersCompanion(isActive: Value(false)));
    } else {
      final payload = change.payload;
      final name = payload['name'] as String? ?? '';
      final isActive = payload['isActive'] as bool? ?? true;

      final existing = await (_database.select(
        _database.workers,
      )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

      if (existing == null) {
        await _database
            .into(_database.workers)
            .insertOnConflictUpdate(
              WorkersCompanion(
                id: Value(change.recordId),
                name: Value(name),
                isActive: Value(isActive),
                createdAt: Value(
                  DateTime.now(), // Use server timestamp if available
                ),
              ),
            );
      } else {
        await (_database.update(
          _database.workers,
        )..where((t) => t.id.equals(change.recordId))).write(
          WorkersCompanion(name: Value(name), isActive: Value(isActive)),
        );
      }
    }
  }

  Future<void> _applyWorkerProductionChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.delete(
        _database.workerProductionEntries,
      )..where((t) => t.id.equals(change.recordId))).go();
    } else {
      final payload = change.payload;
      final workerId = payload['workerId'] as int?;
      final date = DateTime.tryParse(payload['date'] as String? ?? '');
      final stitchCount = (payload['stitchCount'] as num?)?.toInt() ?? 0;
      final notes = payload['notes'] as String?;

      if (workerId != null && date != null) {
        final existing = await (_database.select(
          _database.workerProductionEntries,
        )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

        if (existing == null) {
          await _database
              .into(_database.workerProductionEntries)
              .insert(
                WorkerProductionEntriesCompanion(
                  id: Value(change.recordId),
                  workerId: Value(workerId),
                  date: Value(date),
                  stitchCount: Value(stitchCount),
                  notes: Value(notes),
                ),
              );
        } else {
          await (_database.update(
            _database.workerProductionEntries,
          )..where((t) => t.id.equals(change.recordId))).write(
            WorkerProductionEntriesCompanion(
              workerId: Value(workerId),
              date: Value(date),
              stitchCount: Value(stitchCount),
              notes: Value(notes),
            ),
          );
        }
      }
    }
  }

  Future<void> _applyWorkerAdvanceChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.delete(
        _database.workerAdvances,
      )..where((t) => t.id.equals(change.recordId))).go();
    } else {
      final payload = change.payload;
      final workerId = payload['workerId'] as int?;
      final amount = (payload['amount'] as num?)?.toDouble() ?? 0;
      final date = DateTime.tryParse(payload['date'] as String? ?? '');
      final notes = payload['notes'] as String?;
      final carriedOver = payload['carriedOver'] as bool? ?? false;

      if (workerId != null && date != null) {
        final existing = await (_database.select(
          _database.workerAdvances,
        )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

        if (existing == null) {
          await _database
              .into(_database.workerAdvances)
              .insert(
                WorkerAdvancesCompanion(
                  id: Value(change.recordId),
                  workerId: Value(workerId),
                  amount: Value(amount),
                  date: Value(date),
                  notes: Value(notes),
                  carriedOver: Value(carriedOver),
                ),
              );
        } else {
          await (_database.update(
            _database.workerAdvances,
          )..where((t) => t.id.equals(change.recordId))).write(
            WorkerAdvancesCompanion(
              workerId: Value(workerId),
              amount: Value(amount),
              date: Value(date),
              notes: Value(notes),
              carriedOver: Value(carriedOver),
            ),
          );
        }
      }
    }
  }

  Future<void> _applyStitchRateChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.delete(
        _database.stitchRates,
      )..where((t) => t.id.equals(change.recordId))).go();
    } else {
      final payload = change.payload;
      final rate = (payload['rate'] as num?)?.toDouble() ?? 0;
      final effectiveFrom = DateTime.tryParse(
        payload['effectiveFrom'] as String? ?? '',
      );

      if (effectiveFrom != null) {
        final existing = await (_database.select(
          _database.stitchRates,
        )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

        if (existing == null) {
          await _database
              .into(_database.stitchRates)
              .insert(
                StitchRatesCompanion(
                  id: Value(change.recordId),
                  rate: Value(rate),
                  effectiveFrom: Value(effectiveFrom),
                ),
              );
        } else {
          await (_database.update(
            _database.stitchRates,
          )..where((t) => t.id.equals(change.recordId))).write(
            StitchRatesCompanion(
              rate: Value(rate),
              effectiveFrom: Value(effectiveFrom),
            ),
          );
        }
      }
    }
  }

  Future<void> _applyWorkerAbsentChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.delete(
        _database.workerAbsentDays,
      )..where((t) => t.id.equals(change.recordId))).go();
    } else {
      final payload = change.payload;
      final workerId = payload['workerId'] as int?;
      final monthStart = DateTime.tryParse(
        payload['monthStart'] as String? ?? '',
      );
      final absentDays = (payload['absentDays'] as num?)?.toInt() ?? 0;

      if (workerId != null && monthStart != null) {
        final existing = await (_database.select(
          _database.workerAbsentDays,
        )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

        if (existing == null) {
          await _database
              .into(_database.workerAbsentDays)
              .insert(
                WorkerAbsentDaysCompanion(
                  id: Value(change.recordId),
                  workerId: Value(workerId),
                  monthStart: Value(monthStart),
                  absentDays: Value(absentDays),
                ),
              );
        } else {
          await (_database.update(
            _database.workerAbsentDays,
          )..where((t) => t.id.equals(change.recordId))).write(
            WorkerAbsentDaysCompanion(
              workerId: Value(workerId),
              monthStart: Value(monthStart),
              absentDays: Value(absentDays),
            ),
          );
        }
      }
    }
  }

  Future<void> _applyWomenStaffChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.update(_database.womenStaffMembers)
            ..where((t) => t.id.equals(change.recordId)))
          .write(const WomenStaffMembersCompanion(isActive: Value(false)));
    } else {
      final payload = change.payload;
      final name = payload['name'] as String? ?? '';
      final isActive = payload['isActive'] as bool? ?? true;

      final existing = await (_database.select(
        _database.womenStaffMembers,
      )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

      if (existing == null) {
        await _database
            .into(_database.womenStaffMembers)
            .insertOnConflictUpdate(
              WomenStaffMembersCompanion(
                id: Value(change.recordId),
                name: Value(name),
                isActive: Value(isActive),
                createdAt: Value(DateTime.now()),
              ),
            );
      } else {
        await (_database.update(
          _database.womenStaffMembers,
        )..where((t) => t.id.equals(change.recordId))).write(
          WomenStaffMembersCompanion(
            name: Value(name),
            isActive: Value(isActive),
          ),
        );
      }
    }
  }

  Future<void> _applyStaffAdvanceChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.delete(
        _database.staffAdvances,
      )..where((t) => t.id.equals(change.recordId))).go();
    } else {
      final payload = change.payload;
      final staffId = payload['staffId'] as int?;
      final amount = (payload['amount'] as num?)?.toDouble() ?? 0;
      final date = DateTime.tryParse(payload['date'] as String? ?? '');
      final notes = payload['notes'] as String?;
      final carriedOver = payload['carriedOver'] as bool? ?? false;

      if (staffId != null && date != null) {
        final existing = await (_database.select(
          _database.staffAdvances,
        )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

        if (existing == null) {
          await _database
              .into(_database.staffAdvances)
              .insert(
                StaffAdvancesCompanion(
                  id: Value(change.recordId),
                  staffId: Value(staffId),
                  amount: Value(amount),
                  date: Value(date),
                  notes: Value(notes),
                  carriedOver: Value(carriedOver),
                ),
              );
        } else {
          await (_database.update(
            _database.staffAdvances,
          )..where((t) => t.id.equals(change.recordId))).write(
            StaffAdvancesCompanion(
              staffId: Value(staffId),
              amount: Value(amount),
              date: Value(date),
              notes: Value(notes),
              carriedOver: Value(carriedOver),
            ),
          );
        }
      }
    }
  }

  Future<void> _applySupplierChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      // Mark as deleted or actually delete
      final existing = await (_database.select(
        _database.suppliers,
      )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();
      if (existing != null) {
        await (_database.delete(
          _database.suppliers,
        )..where((t) => t.id.equals(change.recordId))).go();
      }
    } else {
      final payload = change.payload;
      final name = payload['name'] as String? ?? '';
      final phone = payload['phone'] as String?;

      final existing = await (_database.select(
        _database.suppliers,
      )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

      if (existing == null) {
        await _database
            .into(_database.suppliers)
            .insertOnConflictUpdate(
              SuppliersCompanion(
                id: Value(change.recordId),
                name: Value(name),
                phone: Value(phone),
                createdAt: Value(DateTime.now()),
              ),
            );
      } else {
        await (_database.update(_database.suppliers)
              ..where((t) => t.id.equals(change.recordId)))
            .write(SuppliersCompanion(name: Value(name), phone: Value(phone)));
      }
    }
  }

  Future<void> _applyThreadPurchaseChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.delete(
        _database.threadPurchases,
      )..where((t) => t.id.equals(change.recordId))).go();
    } else {
      final payload = change.payload;
      final supplierId = payload['supplierId'] as int?;
      final itemName = payload['itemName'] as String? ?? '';
      final colorNumber = payload['colorNumber'] as String? ?? '';
      final purchaseDate = DateTime.tryParse(
        payload['purchaseDate'] as String? ?? '',
      );
      final price = (payload['price'] as num?)?.toDouble() ?? 0;
      final quantity = (payload['quantity'] as num?)?.toDouble() ?? 0;
      final unit = payload['unit'] as String? ?? '';
      final notes = payload['notes'] as String?;

      if (supplierId != null && purchaseDate != null) {
        final existing = await (_database.select(
          _database.threadPurchases,
        )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

        if (existing == null) {
          await _database
              .into(_database.threadPurchases)
              .insert(
                ThreadPurchasesCompanion(
                  id: Value(change.recordId),
                  supplierId: Value(supplierId),
                  itemName: Value(itemName),
                  colorNumber: Value(colorNumber),
                  purchaseDate: Value(purchaseDate),
                  price: Value(price),
                  quantity: Value(quantity),
                  unit: Value(unit),
                  notes: Value(notes),
                ),
              );
        } else {
          await (_database.update(
            _database.threadPurchases,
          )..where((t) => t.id.equals(change.recordId))).write(
            ThreadPurchasesCompanion(
              supplierId: Value(supplierId),
              itemName: Value(itemName),
              colorNumber: Value(colorNumber),
              purchaseDate: Value(purchaseDate),
              price: Value(price),
              quantity: Value(quantity),
              unit: Value(unit),
              notes: Value(notes),
            ),
          );
        }
      }
    }
  }

  Future<void> _applySupplierPaymentChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.delete(
        _database.supplierPayments,
      )..where((t) => t.id.equals(change.recordId))).go();
    } else {
      final payload = change.payload;
      final supplierId = payload['supplierId'] as int?;
      final amount = (payload['amount'] as num?)?.toDouble() ?? 0;
      final paymentDate = DateTime.tryParse(
        payload['paymentDate'] as String? ?? '',
      );
      final notes = payload['notes'] as String?;

      if (supplierId != null && paymentDate != null) {
        final existing = await (_database.select(
          _database.supplierPayments,
        )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

        if (existing == null) {
          await _database
              .into(_database.supplierPayments)
              .insert(
                SupplierPaymentsCompanion(
                  id: Value(change.recordId),
                  supplierId: Value(supplierId),
                  amount: Value(amount),
                  paymentDate: Value(paymentDate),
                  notes: Value(notes),
                ),
              );
        } else {
          await (_database.update(
            _database.supplierPayments,
          )..where((t) => t.id.equals(change.recordId))).write(
            SupplierPaymentsCompanion(
              supplierId: Value(supplierId),
              amount: Value(amount),
              paymentDate: Value(paymentDate),
              notes: Value(notes),
            ),
          );
        }
      }
    }
  }

  Future<void> _applyClientChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.update(_database.clients)
            ..where((t) => t.id.equals(change.recordId)))
          .write(const ClientsCompanion(isActive: Value(false)));
    } else {
      final payload = change.payload;
      final name = payload['name'] as String? ?? '';
      final phone = payload['phone'] as String?;
      final isActive = payload['isActive'] as bool? ?? true;

      final existing = await (_database.select(
        _database.clients,
      )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

      if (existing == null) {
        await _database
            .into(_database.clients)
            .insertOnConflictUpdate(
              ClientsCompanion(
                id: Value(change.recordId),
                name: Value(name),
                phone: Value(phone),
                isActive: Value(isActive),
                createdAt: Value(DateTime.now()),
              ),
            );
      } else {
        await (_database.update(
          _database.clients,
        )..where((t) => t.id.equals(change.recordId))).write(
          ClientsCompanion(
            name: Value(name),
            phone: Value(phone),
            isActive: Value(isActive),
          ),
        );
      }
    }
  }

  Future<void> _applyClientModelChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.delete(
        _database.clientModels,
      )..where((t) => t.id.equals(change.recordId))).go();
    } else {
      final payload = change.payload;
      final clientId = payload['clientId'] as int?;
      final modelName = payload['modelName'] as String? ?? '';
      final pieceCount = (payload['pieceCount'] as num?)?.toInt() ?? 0;
      final pricePerPiece = (payload['pricePerPiece'] as num?)?.toDouble() ?? 0;
      final date = DateTime.tryParse(payload['date'] as String? ?? '');
      final notes = payload['notes'] as String?;

      if (clientId != null && date != null) {
        final existing = await (_database.select(
          _database.clientModels,
        )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

        if (existing == null) {
          await _database
              .into(_database.clientModels)
              .insert(
                ClientModelsCompanion(
                  id: Value(change.recordId),
                  clientId: Value(clientId),
                  modelName: Value(modelName),
                  pieceCount: Value(pieceCount),
                  pricePerPiece: Value(pricePerPiece),
                  date: Value(date),
                  notes: Value(notes),
                ),
              );
        } else {
          await (_database.update(
            _database.clientModels,
          )..where((t) => t.id.equals(change.recordId))).write(
            ClientModelsCompanion(
              clientId: Value(clientId),
              modelName: Value(modelName),
              pieceCount: Value(pieceCount),
              pricePerPiece: Value(pricePerPiece),
              date: Value(date),
              notes: Value(notes),
            ),
          );
        }
      }
    }
  }

  Future<void> _applyClientPaymentChange(RemoteChangeEvent change) async {
    if (change.operation == SyncQueueOperation.delete) {
      await (_database.delete(
        _database.clientPayments,
      )..where((t) => t.id.equals(change.recordId))).go();
    } else {
      final payload = change.payload;
      final clientId = payload['clientId'] as int?;
      final amount = (payload['amount'] as num?)?.toDouble() ?? 0;
      final paymentDate = DateTime.tryParse(
        payload['paymentDate'] as String? ?? '',
      );
      final notes = payload['notes'] as String?;

      if (clientId != null && paymentDate != null) {
        final existing = await (_database.select(
          _database.clientPayments,
        )..where((t) => t.id.equals(change.recordId))).getSingleOrNull();

        if (existing == null) {
          await _database
              .into(_database.clientPayments)
              .insert(
                ClientPaymentsCompanion(
                  id: Value(change.recordId),
                  clientId: Value(clientId),
                  amount: Value(amount),
                  paymentDate: Value(paymentDate),
                  notes: Value(notes),
                ),
              );
        } else {
          await (_database.update(
            _database.clientPayments,
          )..where((t) => t.id.equals(change.recordId))).write(
            ClientPaymentsCompanion(
              clientId: Value(clientId),
              amount: Value(amount),
              paymentDate: Value(paymentDate),
              notes: Value(notes),
            ),
          );
        }
      }
    }
  }
}
