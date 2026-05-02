import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/export/excel_export_service.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../bloc/threads_cubit.dart';
import '../bloc/threads_state.dart';
import '../widgets/supplier_summary_card.dart';
import '../widgets/threads_forms.dart';

class ThreadsPage extends StatelessWidget {
  const ThreadsPage({super.key});

  static const String routeName = 'threads';
  static const String routePath = '/threads';
  static String detailsPath(int supplierId) => '$routePath/details/$supplierId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ThreadsCubit>()..start(),
      child: const _ThreadsView(),
    );
  }
}

class _ThreadsView extends StatelessWidget {
  const _ThreadsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThreadsCubit, ThreadsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final currency = NumberFormat.currency(
          locale: Localizations.localeOf(context).toLanguageTag(),
          symbol: 'EGP ',
          decimalDigits: 2,
        );

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.threads,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 320,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: l10n.threadsSearchHint,
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: context
                              .read<ThreadsCubit>()
                              .updateSearchQuery,
                        ),
                      ),
                      MonthSelector(
                        month: state.selectedMonth,
                        onPrevious: context.read<ThreadsCubit>().previousMonth,
                        onNext: context.read<ThreadsCubit>().nextMonth,
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            await GetIt.I<ExcelExportService>().exportThreads(
                              suppliers: state.items,
                              allPurchases: const [],
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
                        icon: const Icon(Icons.table_chart_outlined),
                        label: Text(l10n.exportExcel),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      _OverviewCard(
                        label: l10n.monthlyPurchases,
                        value: currency.format(state.overview.monthlyPurchased),
                      ),
                      _OverviewCard(
                        label: l10n.yearlyPurchases,
                        value: currency.format(state.overview.yearlyPurchased),
                      ),
                      _OverviewCard(
                        label: l10n.yearlyPayments,
                        value: currency.format(state.overview.yearlyPaid),
                      ),
                      _OverviewCard(
                        label: l10n.totalOutstanding,
                        value: currency.format(state.overview.totalOutstanding),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.filteredItems.isEmpty
                        ? Center(child: Text(l10n.noSuppliersYet))
                        : ListView.separated(
                            itemCount: state.filteredItems.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final item = state.filteredItems[index];
                              return SupplierSummaryCard(
                                item: item,
                                onTap: () => context.push(
                                  ThreadsPage.detailsPath(item.id),
                                ),
                                onDelete: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(l10n.deleteSupplierTitle),
                                      content: Text(
                                        l10n.confirmDeleteSupplier(item.name),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text(l10n.cancel),
                                        ),
                                        FilledButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text(l10n.delete),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (shouldDelete == true && context.mounted) {
                                    await context
                                        .read<ThreadsCubit>()
                                        .deleteSupplier(item.id);
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await showSupplierSheet(context);
              if (result != null && context.mounted) {
                await context.read<ThreadsCubit>().addSupplier(
                  name: result.name,
                  phone: result.phone,
                );
              }
            },
            icon: const Icon(Icons.add_business_outlined),
            label: Text(l10n.addSupplier),
          ),
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              const SizedBox(height: AppSpacing.sm),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
