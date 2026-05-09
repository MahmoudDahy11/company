import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/export/excel_export_service.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/thread_purchase.dart';
import '../../domain/entities/supplier_list_item.dart';
import '../bloc/threads_cubit.dart';
import 'supplier_form_sheet.dart';

class ThreadsHeaderWidget extends StatelessWidget {
  const ThreadsHeaderWidget({
    super.key,
    required this.items,
    required this.allPurchases,
    required this.selectedMonth,
  });

  final List<SupplierListItem> items;
  final List<ThreadPurchase> allPurchases;
  final DateTime selectedMonth;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < AppBreakpoints.mobile;
    final l10n = AppLocalizations.of(context)!;
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text(l10n.threads, style: _title(context, true))],
          ),
          const SizedBox(height: AppSpacing.md),
          _search(context, l10n),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _actions(context, l10n)),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: _actions(context, l10n)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _search(context, l10n),
            const SizedBox(width: AppSpacing.lg),
            Text(l10n.threads, style: _title(context, false)),
          ],
        ),
      ],
    );
  }

  List<Widget> _actions(BuildContext context, AppLocalizations l10n) {
    return [
      FilledButton.icon(
        onPressed: () async {
          final r = await showSupplierSheet(context);
          if (r != null && context.mounted) {
            await context.read<ThreadsCubit>().addSupplier(
              name: r.name,
              phone: r.phone,
            );
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addSupplier),
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
        onPressed: () => _export(context, l10n),
        icon: const Icon(Icons.download_outlined),
        label: Text(l10n.exportExcel),
      ),
    ];
  }

  Future<void> _export(BuildContext context, AppLocalizations l10n) async {
    try {
      await GetIt.I<ExcelExportService>().exportThreads(
        suppliers: items,
        allPurchases: allPurchases,
        month: selectedMonth,
        isArabic: Localizations.localeOf(context).languageCode == 'ar',
      );
      if (context.mounted) _snack(context, l10n.exportSuccess);
    } catch (_) {
      if (context.mounted) _snack(context, l10n.exportError);
    }
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _search(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: 250,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          hintText: l10n.threadsSearchHint,
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onChanged: context.read<ThreadsCubit>().updateSearchQuery,
      ),
    );
  }

  TextStyle? _title(BuildContext context, bool mobile) {
    final size = mobile
        ? Theme.of(context).textTheme.headlineSmall
        : Theme.of(context).textTheme.headlineMedium;
    return size?.copyWith(
      fontWeight: FontWeight.bold,
      color: const Color(0xFF1F2937),
    );
  }
}
