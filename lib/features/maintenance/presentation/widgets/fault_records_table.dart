import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/maintenance_fault_record.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../bloc/maintenance_fault_records_cubit.dart';
import '../models/fault_record_form_result.dart';
import 'delete_record_dialog.dart';
import 'fault_record_form.dart';

class FaultRecordsTable extends StatelessWidget {
  const FaultRecordsTable({required this.items, super.key});

  final List<MaintenanceFaultRecord> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder.all(color: Colors.grey.shade200, width: 1),
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          headingTextStyle: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.bold,
          ),
          dataRowMaxHeight: 64,
          dataRowMinHeight: 64,
          columns: [
            DataColumn(label: Text(l10n.machineName)),
            DataColumn(label: Text(l10n.faultName)),
            DataColumn(label: Text(l10n.cost)),
            DataColumn(label: Text(l10n.totalCost)),
            DataColumn(label: Text(l10n.actions)),
          ],
          rows: items.map((item) {
            final currencyFormat = NumberFormat.currency(
              locale: Localizations.localeOf(context).toLanguageTag(),
              symbol: '',
              decimalDigits: 2,
            );
            return DataRow(
              cells: [
                DataCell(Text(item.machineName)),
                DataCell(Text(item.faultName)),
                DataCell(Text(currencyFormat.format(item.cost).trim())),
                DataCell(Text(currencyFormat.format(item.totalCost).trim())),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final result = await showFaultRecordSheet(
                            context,
                            initialValue: FaultRecordFormResult(
                              id: item.id,
                              machineName: item.machineName,
                              faultName: item.faultName,
                              cost: item.cost,
                              totalCost: item.totalCost,
                            ),
                          );
                          if (result != null && context.mounted) {
                            await context
                                .read<MaintenanceFaultRecordsCubit>()
                                .updateRecord(
                                  id: result.id!,
                                  machineName: result.machineName,
                                  faultName: result.faultName,
                                  cost: result.cost,
                                  totalCost: result.totalCost,
                                );
                          }
                        },
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: l10n.editFaultRecord,
                      ),
                      IconButton(
                        onPressed: () async {
                          final confirm = await showDeleteConfirmation(
                            context,
                            item.machineName,
                          );
                          if (confirm == true && context.mounted) {
                            await context
                                .read<MaintenanceFaultRecordsCubit>()
                                .deleteRecord(item.id);
                          }
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        tooltip: l10n.delete,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
