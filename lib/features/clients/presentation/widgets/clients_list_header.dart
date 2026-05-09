import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/export/excel_export_service.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/clients_cubit.dart';

import 'client_form_sheet.dart';

class ClientsListHeader extends StatelessWidget {
  const ClientsListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ClientsCubit>().state;
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.sizeOf(context).width < AppBreakpoints.mobile;

    final actionButtons = [
      FilledButton.icon(
        onPressed: () async {
          final result = await showClientSheet(context);
          if (result != null && context.mounted) {
            await context.read<ClientsCubit>().addClient(
              name: result.name,
              phone: result.phone,
            );
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addClient),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF374151),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),
      const SizedBox(width: AppSpacing.md),
      OutlinedButton.icon(
        onPressed: () async {
          try {
            await GetIt.I<ExcelExportService>().exportClients(
              clients: state.items,
              month: state.selectedMonth,
              isArabic: Localizations.localeOf(context).languageCode == 'ar',
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.exportSuccess)),
              );
            }
          } catch (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.exportError)),
              );
            }
          }
        },
        icon: const Icon(Icons.download_outlined),
        label: Text(l10n.exportExcel),
      ),
    ];

    final searchField = SizedBox(
      width: isMobile ? double.infinity : 250,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          hintText: l10n.clientsSearchHint,
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onChanged: context.read<ClientsCubit>().updateSearchQuery,
      ),
    );
    final title = Text(
      l10n.clients,
      style: (isMobile
              ? Theme.of(context).textTheme.headlineSmall
              : Theme.of(context).textTheme.headlineMedium)
          ?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [title]),
          const SizedBox(height: AppSpacing.md),
          searchField,
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: actionButtons),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: actionButtons),
        Row(mainAxisSize: MainAxisSize.min, children: [searchField, const SizedBox(width: AppSpacing.lg), title]),
      ],
    );
  }
}
