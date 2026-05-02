import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/export/excel_export_service.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/clients_cubit.dart';
import '../bloc/clients_state.dart';
import '../widgets/clients_forms.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  static const String routeName = 'clients';
  static const String routePath = '/clients';
  static String detailsPath(int clientId) => '$routePath/details/$clientId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ClientsCubit>()..start(),
      child: const _ClientsView(),
    );
  }
}

class _ClientsView extends StatelessWidget {
  const _ClientsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsCubit, ClientsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
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
                                await GetIt.I<ExcelExportService>()
                                    .exportClients(
                                      clients: state.items,
                                      month: state.selectedMonth,
                                      isArabic:
                                          Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar',
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
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 250,
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: l10n.clientsSearchHint,
                                prefixIcon: const Icon(Icons.search),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              onChanged: context
                                  .read<ClientsCubit>()
                                  .updateSearchQuery,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Text(
                            l10n.clients,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1F2937),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.filteredItems.isEmpty
                      ? Center(child: Text(l10n.noClientsYet))
                      : Card(
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
                                  l10n.clientsList,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1F2937),
                                      ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  border: TableBorder.all(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                  headingRowColor: WidgetStateProperty.all(
                                    Colors.grey.shade50,
                                  ),
                                  headingTextStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  dataRowMaxHeight: 64,
                                  dataRowMinHeight: 64,
                                  columns: [
                                    DataColumn(label: Text(l10n.name)),
                                    DataColumn(
                                      label: Text(
                                        l10n.totalAmountHeader,
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(l10n.totalPaidHeader),
                                    ),
                                    DataColumn(
                                      label: Text(l10n.remainingBalance),
                                    ),
                                    DataColumn(label: Text(l10n.actions)),
                                  ],
                                  rows: state.filteredItems.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name)),
                                        DataCell(
                                          Text(
                                            NumberFormat.currency(
                                                  locale:
                                                      Localizations.localeOf(
                                                        context,
                                                      ).toLanguageTag(),
                                                  symbol: '',
                                                  decimalDigits: 2,
                                                )
                                                .format(item.totalAmount)
                                                .trim(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            NumberFormat.currency(
                                              locale:
                                                  Localizations.localeOf(
                                                    context,
                                                  ).toLanguageTag(),
                                              symbol: '',
                                              decimalDigits: 2,
                                            ).format(item.totalPaid).trim(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            NumberFormat.currency(
                                                  locale:
                                                      Localizations.localeOf(
                                                        context,
                                                      ).toLanguageTag(),
                                                  symbol: '',
                                                  decimalDigits: 2,
                                                )
                                                .format(
                                                  item.outstanding,
                                                )
                                                .trim(),
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
                                                onPressed: () => context.push(
                                                  ClientsPage.detailsPath(
                                                    item.id,
                                                  ),
                                                ),
                                                style:
                                                    OutlinedButton.styleFrom(
                                                      foregroundColor:
                                                          const Color(
                                                            0xFF1F2937,
                                                          ),
                                                      side: BorderSide(
                                                        color: Colors
                                                            .grey
                                                            .shade300,
                                                      ),
                                                    ),
                                                child: Text(l10n.details),
                                              ),
                                              const SizedBox(
                                                width: AppSpacing.sm,
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  final confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text(
                                                        l10n.deleteClientTitle,
                                                      ),
                                                      content: Text(
                                                        l10n.confirmDeleteClient(
                                                          item.name,
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                                false,
                                                              ),
                                                          child: Text(
                                                            l10n.cancel,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                                true,
                                                              ),
                                                          style: TextButton.styleFrom(
                                                            foregroundColor:
                                                                Colors.red,
                                                          ),
                                                          child: Text(
                                                            l10n.delete,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm == true &&
                                                      context.mounted) {
                                                    context
                                                        .read<
                                                          ClientsCubit
                                                        >()
                                                        .deleteClient(
                                                          item.id,
                                                        );
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
