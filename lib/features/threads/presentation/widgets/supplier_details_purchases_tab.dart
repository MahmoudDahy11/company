import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/thread_purchase.dart';
import '../bloc/supplier_details_cubit.dart';
import 'delete_purchase_dialog.dart';
import 'form_result_classes.dart';
import 'purchase_form_sheet.dart';

class SupplierDetailsPurchasesTab extends StatelessWidget {
  const SupplierDetailsPurchasesTab({super.key, required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final details = context.select((SupplierDetailsCubit c) => c.state.details);
    final purchases = details?.purchases ?? [];
    final l10n = AppLocalizations.of(context)!;
    if (purchases.isEmpty) return _emptyState(context);

    return RefreshIndicator(
      onRefresh: () => context.read<SupplierDetailsCubit>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            headingRowColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            border: TableBorder.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
            columns: [
              DataColumn(label: Text(l10n.date)),
              DataColumn(label: Text(l10n.itemType)),
              DataColumn(label: Text(l10n.colorNumber)),
              DataColumn(label: Text(l10n.price)),
              DataColumn(label: Text(l10n.quantity)),
              DataColumn(label: Text(l10n.notes)),
              DataColumn(label: Text(l10n.actions)),
            ],
            rows: purchases
                .map(
                  (item) => DataRow(
                    cells: [
                      DataCell(
                        Text(DateFormat.yMd().format(item.purchaseDate)),
                      ),
                      DataCell(Text(item.itemName)),
                      DataCell(Text(item.colorNumber)),
                      DataCell(Text(currency.format(item.price))),
                      DataCell(Text('${item.quantity} ${item.unit}')),
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            item.notes ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _editBtn(context, item),
                            IconButton(
                              onPressed: () async {
                                final confirm = await showDeletePurchaseDialog(
                                  context,
                                );
                                if (confirm == true && context.mounted) {
                                  context
                                      .read<SupplierDetailsCubit>()
                                      .deletePurchase(item.id);
                                }
                              },
                              icon: const Icon(Icons.delete_outline, size: 20),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _editBtn(BuildContext context, ThreadPurchase item) {
    return IconButton(
      onPressed: () async {
        final r = await showPurchaseSheet(
          context,
          initialValue: PurchaseFormResult(
            purchaseId: item.id,
            itemName: item.itemName,
            colorNumber: item.colorNumber,
            purchaseDate: item.purchaseDate,
            price: item.price,
            quantity: item.quantity,
            unit: item.unit,
            notes: item.notes,
          ),
        );
        if (r != null && context.mounted) {
          await context.read<SupplierDetailsCubit>().savePurchase(
            purchaseId: item.id,
            itemName: r.itemName,
            colorNumber: r.colorNumber,
            purchaseDate: r.purchaseDate,
            price: r.price,
            quantity: r.quantity,
            unit: r.unit,
            notes: r.notes,
          );
        }
      },
      icon: const Icon(Icons.edit_outlined, size: 20),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _emptyState(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<SupplierDetailsCubit>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Center(
            child: Text(AppLocalizations.of(context)!.noPurchasesThisMonth),
          ),
        ),
      ),
    );
  }
}
