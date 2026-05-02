import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../bloc/client_details_cubit.dart';
import '../bloc/client_details_state.dart';
import '../widgets/clients_forms.dart';

class ClientDetailsPage extends StatelessWidget {
  const ClientDetailsPage({super.key, required this.clientId});

  static const String routeName = 'client-details';
  static const String routePath = 'details/:clientId';

  final int clientId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ClientDetailsCubit>()..init(clientId),
      child: const _ClientDetailsView(),
    );
  }
}

class _ClientDetailsView extends StatelessWidget {
  const _ClientDetailsView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocBuilder<ClientDetailsCubit, ClientDetailsState>(
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          final details = state.details;
          final currency = NumberFormat.currency(
            locale: Localizations.localeOf(context).toLanguageTag(),
            symbol: 'EGP ',
            decimalDigits: 2,
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(details?.client.name ?? l10n.clientDetailsTitle),
              bottom: TabBar(
                tabs: [
                  Tab(text: l10n.modelsTab),
                  Tab(text: l10n.paymentsTab),
                ],
              ),
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : details == null
                ? Center(
                    child: Text(state.errorMessage ?? l10n.failedToLoadData),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MonthSelector(
                              month: state.selectedMonth,
                              onPrevious: context
                                  .read<ClientDetailsCubit>()
                                  .previousMonth,
                              onNext: context
                                  .read<ClientDetailsCubit>()
                                  .nextMonth,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              details.client.phone == null
                                  ? l10n.noPhoneNumber
                                  : l10n.phone(details.client.phone!),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.outstanding(
                                currency.format(details.summary.outstanding),
                              ),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _ModelsTab(currency: currency),
                            _PaymentsTab(currency: currency),
                          ],
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: PopupMenuButton<VoidCallback>(
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
            ),
          );
        },
      ),
    );
  }
}

class _ModelsTab extends StatelessWidget {
  const _ModelsTab({required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final details = context.select(
      (ClientDetailsCubit cubit) => cubit.state.details,
    );
    final models = details?.models ?? const [];
    if (models.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noModelsThisMonth),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
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
              return DataRow(
                cells: [
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
                  DataCell(
                    IconButton(
                      onPressed: () => context
                          .read<ClientDetailsCubit>()
                          .deleteModel(item.id),
                      icon: const Icon(Icons.delete_outline, size: 20),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _PaymentsTab extends StatelessWidget {
  const _PaymentsTab({required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final details = context.select(
      (ClientDetailsCubit cubit) => cubit.state.details,
    );
    final payments = details?.payments ?? const [];
    if (payments.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noPaymentsThisMonth),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
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
              DataColumn(label: Text(l10n.amount)),
              DataColumn(label: Text(l10n.notes)),
              DataColumn(label: Text(l10n.actions)),
            ],
            rows: payments.map((item) {
              return DataRow(
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
                    IconButton(
                      onPressed: () => context
                          .read<ClientDetailsCubit>()
                          .deletePayment(item.id),
                      icon: const Icon(Icons.delete_outline, size: 20),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
