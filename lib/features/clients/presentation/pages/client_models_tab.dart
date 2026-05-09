import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/client_details_cubit.dart';
import 'client_model_actions.dart';

class ClientModelsTab extends StatelessWidget {
  const ClientModelsTab({super.key, required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final details = context.select(
      (ClientDetailsCubit cubit) => cubit.state.details,
    );
    final models = details?.models ?? const [];
    final l10n = AppLocalizations.of(context)!;

    if (models.isEmpty) {
      return _emptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ClientDetailsCubit>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(thickness: 1, space: 1),
            ),
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
                DataColumn(label: Text(l10n.modelName)),
                DataColumn(label: Text(l10n.pieceCount)),
                DataColumn(label: Text(l10n.pricePerPiece)),
                DataColumn(label: Text(l10n.totalAmountHeader)),
                DataColumn(label: Text(l10n.notes)),
                DataColumn(label: Text(l10n.actions)),
              ],
              rows: models.map((item) {
                return DataRow(cells: [
                  DataCell(Text(DateFormat.yMd().format(item.date))),
                  DataCell(Text(item.modelName)),
                  DataCell(Text(item.pieceCount.toString())),
                  DataCell(Text(currency.format(item.pricePerPiece))),
                  DataCell(Text(currency.format(item.total))),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Text(
                        item.notes ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(ClientModelActions(item: item)),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<ClientDetailsCubit>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Text(AppLocalizations.of(context)!.noModelsThisMonth),
          ),
        ),
      ),
    );
  }
}
