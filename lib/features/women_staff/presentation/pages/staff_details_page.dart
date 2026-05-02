import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../bloc/staff_details_cubit.dart';
import '../bloc/staff_details_state.dart';
import '../widgets/women_staff_forms.dart';

class StaffDetailsPage extends StatelessWidget {
  const StaffDetailsPage({super.key, required this.staffId});

  static const String routeName = 'staff-details';
  static const String routePath = 'details/:staffId';

  final int staffId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<StaffDetailsCubit>()..init(staffId),
      child: const _StaffDetailsView(),
    );
  }
}

class _StaffDetailsView extends StatelessWidget {
  const _StaffDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffDetailsCubit, StaffDetailsState>(
      builder: (context, state) {
        final details = state.details;
        final currency = NumberFormat.currency(
          locale: Localizations.localeOf(context).toLanguageTag(),
          symbol: 'EGP ',
          decimalDigits: 2,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(details?.staffMember.name ?? 'تفاصيل الموظفة'),
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : details == null
              ? Center(child: Text(state.errorMessage ?? 'تعذر تحميل البيانات'))
              : Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MonthSelector(
                        month: state.selectedMonth,
                        onPrevious: context
                            .read<StaffDetailsCubit>()
                            .previousMonth,
                        onNext: context.read<StaffDetailsCubit>().nextMonth,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'تاريخ التسجيل: ${DateFormat.yMd().format(details.staffMember.createdAt)}',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: [
                          _SummaryCard(
                            label: 'الراتب الثابت',
                            value: currency.format(
                              details.summary.monthlySalary,
                            ),
                          ),
                          _SummaryCard(
                            label: 'السلف',
                            value: currency.format(
                              details.summary.totalAdvances,
                            ),
                          ),
                          _SummaryCard(
                            label: 'الترحيل',
                            value: currency.format(details.summary.carryOver),
                          ),
                          _SummaryCard(
                            label: 'الصافي',
                            value: currency.format(details.summary.netSalary),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () async {
                              final salary = await showUpdateSalarySheet(
                                context,
                                initialValue: details.staffMember.monthlySalary,
                              );
                              if (salary != null && context.mounted) {
                                await context
                                    .read<StaffDetailsCubit>()
                                    .updateSalary(salary);
                              }
                            },
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('تعديل الراتب'),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          FilledButton.icon(
                            onPressed: () async {
                              final result = await showStaffAdvanceSheet(
                                context,
                              );
                              if (result != null && context.mounted) {
                                await context
                                    .read<StaffDetailsCubit>()
                                    .addAdvance(
                                      amount: result.amount,
                                      date: result.date,
                                      notes: result.notes,
                                    );
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('إضافة سلفة'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Expanded(
                        child: details.advances.isEmpty
                            ? const Center(
                                child: Text('لا توجد سلف لهذا الشهر'),
                              )
                            : ListView.separated(
                                itemCount: details.advances.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: AppSpacing.md),
                                itemBuilder: (context, index) {
                                  final item = details.advances[index];
                                  return Card(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(
                                        AppSpacing.md,
                                      ),
                                      title: Text(currency.format(item.amount)),
                                      subtitle: Text(
                                        '${DateFormat.yMd().format(item.date)}'
                                        '${item.notes == null ? '' : '\n${item.notes}'}',
                                      ),
                                      trailing: item.carriedOver
                                          ? const Chip(label: Text('ترحيل'))
                                          : IconButton(
                                              onPressed: () => context
                                                  .read<StaffDetailsCubit>()
                                                  .deleteAdvance(item.id),
                                              icon: const Icon(
                                                Icons.delete_outline,
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value});

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
