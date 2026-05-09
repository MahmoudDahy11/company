import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/export/excel_export_service.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/maintenance_fault_records_cubit.dart';
import '../bloc/maintenance_fault_records_state.dart';
import '../widgets/fault_record_form.dart';
import '../widgets/fault_records_table.dart';
import '../widgets/maintenance_header.dart';

class MaintenanceFaultRecordsPage extends StatelessWidget {
  const MaintenanceFaultRecordsPage({super.key});

  static const String routeName = 'maintenance-fault-records';
  static const String routePath = '/maintenance-fault-records';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<MaintenanceFaultRecordsCubit>()..start(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

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
                    MaintenanceHeader(
                      onAdd: () async {
                        final result = await showFaultRecordSheet(context);
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
                      onExport: () async {
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
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state.items.isEmpty)
                      Center(child: Text(l10n.noFaultRecordsYet))
                    else
                      FaultRecordsTable(items: state.items),
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
