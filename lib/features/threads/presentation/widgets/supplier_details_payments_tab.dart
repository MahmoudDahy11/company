import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/supplier_payment.dart';
import '../bloc/supplier_details_cubit.dart';
import 'delete_payment_dialog.dart';
import 'form_result_classes.dart';
import 'payment_form_sheet.dart';

class SupplierDetailsPaymentsTab extends StatelessWidget {
  const SupplierDetailsPaymentsTab({super.key, required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final details = context.select((SupplierDetailsCubit c) => c.state.details);
    final payments = details?.payments ?? [];
    final l10n = AppLocalizations.of(context)!;
    if (payments.isEmpty) return _emptyState(context);

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
              DataColumn(label: Text(l10n.amount)),
              DataColumn(label: Text(l10n.notes)),
              DataColumn(label: Text(l10n.actions)),
            ],
            rows: payments
                .map(
                  (item) => DataRow(
                    cells: [
                      DataCell(Text(DateFormat.yMd().format(item.paymentDate))),
                      DataCell(Text(currency.format(item.amount))),
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
                                final confirm = await showDeletePaymentDialog(
                                  context,
                                  currency.format(item.amount),
                                );
                                if (confirm == true && context.mounted) {
                                  context
                                      .read<SupplierDetailsCubit>()
                                      .deletePayment(item.id);
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

  Widget _editBtn(BuildContext context, SupplierPaymentEntry item) {
    return IconButton(
      onPressed: () async {
        final r = await showSupplierPaymentSheet(
          context,
          initialValue: SupplierPaymentFormResult(
            paymentId: item.id,
            amount: item.amount,
            paymentDate: item.paymentDate,
            notes: item.notes,
          ),
        );
        if (r != null && context.mounted) {
          await context.read<SupplierDetailsCubit>().savePayment(
            paymentId: item.id,
            amount: r.amount,
            paymentDate: r.paymentDate,
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
            child: Text(AppLocalizations.of(context)!.noPaymentsThisMonth),
          ),
        ),
      ),
    );
  }
}
