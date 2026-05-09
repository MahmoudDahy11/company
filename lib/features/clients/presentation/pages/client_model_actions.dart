import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../domain/entities/client_model_entry.dart';
import '../bloc/client_details_cubit.dart';
import '../widgets/client_form_results.dart';
import '../widgets/client_model_sheet.dart';

class ClientModelActions extends StatelessWidget {
  const ClientModelActions({super.key, required this.item});

  final ClientModelEntry item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () async {
            final result = await showClientModelSheet(
              context,
              initialValue: ClientModelFormResult(
                modelId: item.id,
                modelName: item.modelName,
                pieceCount: item.pieceCount,
                pricePerPiece: item.pricePerPiece,
                date: item.date,
                notes: item.notes,
              ),
            );
            if (result != null && context.mounted) {
              await context.read<ClientDetailsCubit>().updateModel(
                modelId: item.id,
                modelName: result.modelName,
                pieceCount: result.pieceCount,
                pricePerPiece: result.pricePerPiece,
                date: result.date,
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
                title: Text(l10n.deleteModelTitle),
                content: Text(l10n.confirmDeleteModel(item.modelName)),
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
              context.read<ClientDetailsCubit>().deleteModel(item.id);
            }
          },
          icon: const Icon(Icons.delete_outline, size: 20),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
