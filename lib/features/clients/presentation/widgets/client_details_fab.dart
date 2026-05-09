import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../bloc/client_details_cubit.dart';
import 'client_model_sheet.dart';
import 'client_payment_sheet.dart';

class ClientDetailsFab extends StatelessWidget {
  const ClientDetailsFab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<VoidCallback>(
      icon: const Icon(Icons.add),
      onSelected: (action) => action(),
      itemBuilder: (context) => [
        PopupMenuItem<VoidCallback>(
          value: () async {
            final result = await showClientModelSheet(context);
            if (result != null && context.mounted) {
              await context.read<ClientDetailsCubit>().addModel(
                modelName: result.modelName,
                pieceCount: result.pieceCount,
                pricePerPiece: result.pricePerPiece,
                date: result.date,
                notes: result.notes,
              );
            }
          },
          child: Text(l10n.addModel),
        ),
        PopupMenuItem<VoidCallback>(
          value: () async {
            final result = await showClientPaymentSheet(context);
            if (result != null && context.mounted) {
              await context.read<ClientDetailsCubit>().addPayment(
                amount: result.amount,
                paymentDate: result.paymentDate,
                notes: result.notes,
              );
            }
          },
          child: Text(l10n.addPayment),
        ),
      ],
    );
  }
}
