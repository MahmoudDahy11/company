import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../workers/presentation/widgets/month_selector.dart';
import '../bloc/women_staff_cubit.dart';
import '../bloc/women_staff_state.dart';
import '../widgets/staff_summary_card.dart';
import '../widgets/women_staff_forms.dart';

class WomenStaffPage extends StatelessWidget {
  const WomenStaffPage({super.key});

  static const String routeName = 'women-staff';
  static const String routePath = '/women-staff';
  static String detailsPath(int staffId) => '$routePath/details/$staffId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<WomenStaffCubit>()..start(),
      child: const _WomenStaffView(),
    );
  }
}

class _WomenStaffView extends StatelessWidget {
  const _WomenStaffView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WomenStaffCubit, WomenStaffState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الحريم',
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
                            hintText: 'ابحث عن موظفة',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: context
                              .read<WomenStaffCubit>()
                              .updateSearchQuery,
                        ),
                      ),
                      MonthSelector(
                        month: state.selectedMonth,
                        onPrevious: context
                            .read<WomenStaffCubit>()
                            .previousMonth,
                        onNext: context.read<WomenStaffCubit>().nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.filteredItems.isEmpty
                        ? const Center(child: Text('لا توجد موظفات حتى الآن'))
                        : ListView.separated(
                            itemCount: state.filteredItems.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final item = state.filteredItems[index];
                              return StaffSummaryCard(
                                item: item,
                                onTap: () => context.push(
                                  WomenStaffPage.detailsPath(item.id),
                                ),
                                onDelete: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('حذف الموظفة'),
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
                                        .read<WomenStaffCubit>()
                                        .deleteStaff(item.id);
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
              final result = await showAddStaffSheet(context);
              if (result != null && context.mounted) {
                await context.read<WomenStaffCubit>().addStaff(
                  name: result.name,
                  monthlySalary: result.monthlySalary,
                );
              }
            },
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: const Text('إضافة موظفة'),
          ),
        );
      },
    );
  }
}
