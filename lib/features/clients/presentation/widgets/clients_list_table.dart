import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/client_list_item.dart';
import 'client_list_item_actions.dart';

class ClientsListTable extends StatelessWidget {
  const ClientsListTable({super.key, required this.items});

  final List<ClientListItem> items;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              l10n.clientsList,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
          SingleChildScrollView(
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
                DataColumn(label: Text(l10n.name)),
                DataColumn(label: Text(l10n.totalAmountHeader)),
                DataColumn(label: Text(l10n.totalPaidHeader)),
                DataColumn(label: Text(l10n.remainingBalance)),
                DataColumn(label: Text(l10n.actions)),
              ],
              rows: items.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.name)),
                    DataCell(Text(_formatCurrency(context, item.totalAmount))),
                    DataCell(Text(_formatCurrency(context, item.totalPaid))),
                    DataCell(
                      Text(
                        _formatCurrency(context, item.outstanding),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataCell(ClientListItemActions(item: item)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(BuildContext context, double value) {
    return NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '',
      decimalDigits: 2,
    ).format(value).trim();
  }
}
