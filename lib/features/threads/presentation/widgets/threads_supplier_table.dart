import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/supplier_list_item.dart';
import '../bloc/threads_cubit.dart';
import '../pages/threads_page.dart';
import 'delete_supplier_dialog.dart';

class ThreadsSupplierTable extends StatelessWidget {
  const ThreadsSupplierTable({super.key, required this.items});

  final List<SupplierListItem> items;

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
              l10n.suppliersList,
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
                DataColumn(label: Text(l10n.totalPurchasesHeader)),
                DataColumn(label: Text(l10n.totalPaidHeader)),
                DataColumn(label: Text(l10n.remainingBalance)),
                DataColumn(label: Text(l10n.actions)),
              ],
              rows: items
                  .map((item) => DataRow(cells: _buildCells(context, item)))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<DataCell> _buildCells(BuildContext context, SupplierListItem item) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final l10n = AppLocalizations.of(context)!;

    return [
      DataCell(Text(item.name)),
      DataCell(Text(_format(locale, item.totalPurchased))),
      DataCell(Text(_format(locale, item.totalPaid))),
      DataCell(
        Text(
          _format(locale, item.outstandingBalance),
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: () => context.push(ThreadsPage.detailsPath(item.id)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1F2937),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Text(l10n.details),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: () => _confirmDelete(context, item),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SupplierListItem item,
  ) async {
    final confirm = await showDeleteSupplierDialog(context, item.name);
    if (confirm == true && context.mounted) {
      context.read<ThreadsCubit>().deleteSupplier(item.id);
    }
  }

  String _format(String locale, double amount) {
    return NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: 2,
    ).format(amount).trim();
  }
}
