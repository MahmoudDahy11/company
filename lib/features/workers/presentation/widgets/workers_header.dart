import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/workers_cubit.dart';

class WorkersHeader extends StatelessWidget {
  const WorkersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.sizeOf(context).width < AppBreakpoints.mobile;

    final title = Text(
      l10n.workers,
      style: (isMobile
              ? Theme.of(context).textTheme.headlineSmall
              : Theme.of(context).textTheme.headlineMedium)
          ?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
    );

    final searchField = SizedBox(
      width: isMobile ? double.infinity : 250,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          hintText: l10n.workersSearchHint,
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onChanged: context.read<WorkersCubit>().updateSearchQuery,
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(alignment: AlignmentDirectional.centerEnd, child: title),
          const SizedBox(height: AppSpacing.md),
          searchField,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        searchField,
        const SizedBox(width: AppSpacing.lg),
        title,
      ],
    );
  }
}
