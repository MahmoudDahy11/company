import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/export/excel_export_service.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/maintenance_fault_records_cubit.dart';
import '../bloc/maintenance_fault_records_state.dart';
import '../widgets/maintenance_fault_records_forms.dart';

class MaintenanceFaultRecordsPage extends StatelessWidget {
  const MaintenanceFaultRecordsPage({super.key});

  static const String routeName = 'maintenance-fault-records';
  static const String routePath = '/maintenance-fault-records';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<MaintenanceFaultRecordsCubit>()..start(),
      child: const _MaintenanceFaultRecordsView(),
    );
  }
}

class _MaintenanceFaultRecordsView extends StatelessWidget {
  const _MaintenanceFaultRecordsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      MaintenanceFaultRecordsCubit,
      MaintenanceFaultRecordsState
    >(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () =>
                  context.read<MaintenanceFaultRecordsCubit>().start(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        final isMobile =
                            MediaQuery.sizeOf(context).width <
                            AppBreakpoints.mobile;

                        final actionButtons = [
                          FilledButton.icon(
                            onPressed: () async {
                              final result = await showFaultRecordSheet(
                                context,
                              );
                              if (result != null && context.mounted) {
                                await context
                                    .read<MaintenanceFaultRecordsCubit>()
                                    .addRecord(
                                      machineName: result.machineName,
                                      faultName: result.faultName,
                                      cost: result.cost,
                                      totalCost: result.totalCost,
                                    );
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addFaultRecord),
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
                                    .exportMaintenanceFaultRecords(
                                      records: state.items,
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
                        ];

                        if (isMobile) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l10n.faultRecords,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1F2937),
                                    ),
                              ),
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
                            Text(
                              l10n.faultRecords,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1F2937),
                                  ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.items.isEmpty
                        ? Center(child: Text(l10n.noFaultRecordsYet))
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
                                    l10n.faultRecords,
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
                                      DataColumn(label: Text(l10n.machineName)),
                                      DataColumn(label: Text(l10n.faultName)),
                                      DataColumn(label: Text(l10n.cost)),
                                      DataColumn(label: Text(l10n.totalCost)),
                                      DataColumn(label: Text(l10n.actions)),
                                    ],
                                    rows: state.items.map((item) {
                                      final currencyFormat =
                                          NumberFormat.currency(
                                            locale: Localizations.localeOf(
                                              context,
                                            ).toLanguageTag(),
                                            symbol: '',
                                            decimalDigits: 2,
                                          );
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(item.machineName)),
                                          DataCell(Text(item.faultName)),
                                          DataCell(
                                            Text(
                                              currencyFormat
                                                  .format(item.cost)
                                                  .trim(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              currencyFormat
                                                  .format(item.totalCost)
                                                  .trim(),
                                            ),
                                          ),
                                          DataCell(
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    final result =
                                                        await showFaultRecordSheet(
                                                          context,
                                                          initialValue:
                                                              FaultRecordFormResult(
                                                                id: item.id,
                                                                machineName: item
                                                                    .machineName,
                                                                faultName: item
                                                                    .faultName,
                                                                cost: item.cost,
                                                                totalCost: item
                                                                    .totalCost,
                                                              ),
                                                        );
                                                    if (result != null &&
                                                        context.mounted) {
                                                      await context
                                                          .read<
                                                            MaintenanceFaultRecordsCubit
                                                          >()
                                                          .updateRecord(
                                                            id: result.id!,
                                                            machineName: result
                                                                .machineName,
                                                            faultName: result
                                                                .faultName,
                                                            cost: result.cost,
                                                            totalCost: result
                                                                .totalCost,
                                                          );
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                  ),
                                                  tooltip: l10n.editFaultRecord,
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    final confirm = await showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text(
                                                          l10n.deleteFaultRecordTitle,
                                                        ),
                                                        content: Text(
                                                          l10n.confirmDeleteFaultRecord(
                                                            item.machineName,
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
                                                                      Colors
                                                                          .red,
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
                                                      await context
                                                          .read<
                                                            MaintenanceFaultRecordsCubit
                                                          >()
                                                          .deleteRecord(
                                                            item.id,
                                                          );
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                  ),
                                                  tooltip: l10n.delete,
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
          ),
        );
      },
    );
  }
}
