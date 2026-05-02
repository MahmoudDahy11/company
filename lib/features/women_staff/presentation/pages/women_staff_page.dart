import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/export/excel_export_service.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/women_staff_cubit.dart';
import '../bloc/women_staff_state.dart';
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
                              final result = await showAddStaffSheet(context);
                              if (result != null && context.mounted) {
                                await context.read<WomenStaffCubit>().addStaff(
                                  name: result.name,
                                  monthlySalary: result.monthlySalary,
                                );
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addStaff),
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
                                    .exportPayroll(
                                      workers: const [],
                                      staff: state.items,
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
                                hintText: l10n.womenStaffSearchHint,
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
                                  .read<WomenStaffCubit>()
                                  .updateSearchQuery,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Text(
                            l10n.womenStaff,
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
                      ? Center(child: Text(l10n.noWomenStaffYet))
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
                                  l10n.womenStaffList,
                                  style: Theme.of(context).textTheme.titleLarge
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
                                    DataColumn(label: Text(l10n.basicSalary)),
                                    DataColumn(
                                      label: Text(l10n.advancesHeader),
                                    ),
                                    DataColumn(
                                      label: Text(l10n.netSalaryHeader),
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
                                              locale: Localizations.localeOf(
                                                context,
                                              ).toLanguageTag(),
                                              symbol: '',
                                              decimalDigits: 2,
                                            ).format(item.monthlySalary).trim(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            NumberFormat.currency(
                                              locale: Localizations.localeOf(
                                                context,
                                              ).toLanguageTag(),
                                              symbol: '',
                                              decimalDigits: 2,
                                            ).format(item.totalAdvances).trim(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            NumberFormat.currency(
                                              locale: Localizations.localeOf(
                                                context,
                                              ).toLanguageTag(),
                                              symbol: '',
                                              decimalDigits: 2,
                                            ).format(item.netSalary).trim(),
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  final confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text(
                                                        l10n.deleteStaffTitle,
                                                      ),
                                                      content: Text(
                                                        l10n.confirmDeleteStaff(
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
                                                          style:
                                                              TextButton.styleFrom(
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
                                                        .read<WomenStaffCubit>()
                                                        .deleteStaff(item.id);
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
