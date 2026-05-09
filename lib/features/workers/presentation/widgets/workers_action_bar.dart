import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/export/excel_export_service.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/workers_cubit.dart';
import 'workers_forms.dart';

class WorkersActionBar extends StatelessWidget {
  const WorkersActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.sizeOf(context).width < AppBreakpoints.mobile;

    final buttons = [
      FilledButton.icon(
        onPressed: () async {
          final name = await showWorkerNameSheet(context);
          if (name != null && context.mounted) {
            await context.read<WorkersCubit>().addWorker(name);
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addWorker),
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
            final state = context.read<WorkersCubit>().state;
            await GetIt.I<ExcelExportService>().exportPayroll(
              workers: state.items,
              staff: const [],
              month: state.selectedMonth,
              isArabic: Localizations.localeOf(context).languageCode == 'ar',
            );
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.exportSuccess)));
            }
          } catch (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.exportError)));
            }
          }
        },
        icon: const Icon(Icons.download_outlined),
        label: Text(l10n.exportExcel),
      ),
      const SizedBox(width: AppSpacing.md),
      OutlinedButton.icon(
        onPressed: () async {
          final rate = await showStitchRateSheet(context);
          if (rate != null && context.mounted) {
            await context.read<WorkersCubit>().updateStitchRate(rate);
          }
        },
        icon: const Icon(Icons.price_change_outlined),
        label: Text(l10n.stitchRate),
      ),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: buttons),
      );
    }
    return Row(children: buttons);
  }
}
