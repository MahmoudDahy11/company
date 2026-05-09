import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/client_list_item.dart';
import '../bloc/clients_cubit.dart';
import '../pages/clients_page.dart';

class ClientListItemActions extends StatelessWidget {
  const ClientListItemActions({super.key, required this.item});

  final ClientListItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () => context.push(ClientsPage.detailsPath(item.id)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1F2937),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Text(l10n.details),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconButton(
          onPressed: () => _deleteClient(context),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ],
    );
  }

  Future<void> _deleteClient(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteClientTitle),
        content: Text(l10n.confirmDeleteClient(item.name)),
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
      context.read<ClientsCubit>().deleteClient(item.id);
    }
  }
}
