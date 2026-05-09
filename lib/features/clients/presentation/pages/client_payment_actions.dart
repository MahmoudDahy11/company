import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../domain/entities/client_payment_entry.dart';
import '../bloc/client_details_cubit.dart';
import '../widgets/client_form_results.dart';
import '../widgets/client_payment_sheet.dart';

class ClientPaymentActions extends StatelessWidget {
  const ClientPaymentActions({
    super.key,
    required this.item,
    required this.currency,
  });

  final ClientPaymentEntry item;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () async {
            final result = await showClientPaymentSheet(
              context,
              initialValue: ClientPaymentFormResult(
                paymentId: item.id,
                amount: item.amount,
                paymentDate: item.paymentDate,
                notes: item.notes,
              ),
            );
            if (result != null && context.mounted) {
              await context.read<ClientDetailsCubit>().updatePayment(
                paymentId: item.id,
                amount: result.amount,
                paymentDate: result.paymentDate,
                notes: result.notes,
              );
            }
          },
          icon: const Icon(Icons.edit_outlined, size: 20),
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(l10n.deletePaymentTitle),
                content: Text(
                  l10n.confirmDeletePayment(currency.format(item.amount)),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: Text(l10n.delete),
                  ),
                ],
              ),
            );
            if (confirm == true && context.mounted) {
              context.read<ClientDetailsCubit>().deletePayment(item.id);
            }
          },
          icon: const Icon(Icons.delete_outline, size: 20),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
