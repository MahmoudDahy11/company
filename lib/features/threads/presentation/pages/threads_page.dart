import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
                    'الخيوط',
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
                          decoration: const InputDecoration(
                            hintText: 'ابحث عن مورد',
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
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      _OverviewCard(
                        label: 'مشتريات الشهر',
                        value: currency.format(state.overview.monthlyPurchased),
                      ),
                      _OverviewCard(
                        label: 'مشتريات السنة',
                        value: currency.format(state.overview.yearlyPurchased),
                      ),
                      _OverviewCard(
                        label: 'مدفوعات السنة',
                        value: currency.format(state.overview.yearlyPaid),
                      ),
                      _OverviewCard(
                        label: 'إجمالي المتبقي',
                        value: currency.format(state.overview.totalOutstanding),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.filteredItems.isEmpty
                        ? const Center(child: Text('لا يوجد موردون حتى الآن'))
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
                                      title: const Text('حذف المورد'),
                                      content: Text(
                                        'هل تريد حذف ${item.name}؟',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('إلغاء'),
                                        ),
                                        FilledButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('حذف'),
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
            label: const Text('إضافة مورد'),
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
