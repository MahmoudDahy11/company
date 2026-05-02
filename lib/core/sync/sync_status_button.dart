import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../database/app_database.dart';
import '../localization/generated/app_localizations.dart';
import '../utils/app_breakpoints.dart';
import '../utils/app_spacing.dart';
import 'sync_queue_table.dart';
import 'sync_service.dart';
import 'sync_status_cubit.dart';

class SyncStatusButton extends StatelessWidget {
  const SyncStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = GetIt.I<SyncStatusCubit>();

    return BlocBuilder<SyncStatusCubit, SyncStatusState>(
      bloc: cubit,
      builder: (context, state) {
        final visual = _visualFor(context, state.indicatorState);

        return IconButton(
          tooltip: visual.label,
          onPressed: () => _showDetails(context),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              if (state.indicatorState == SyncIndicatorState.syncing)
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(visual.color),
                  ),
                )
              else
                Icon(visual.icon, color: visual.color),
              if (state.pendingCount + state.failedCount > 0)
                PositionedDirectional(
                  top: -4,
                  end: -6,
                  child: _SyncBadge(
                    count: state.pendingCount + state.failedCount,
                    isError: state.failedCount > 0,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDetails(BuildContext context) async {
    final service = GetIt.I<SyncService>();
    final entries = await service.getPendingOrFailedEntries();

    if (!context.mounted) {
      return;
    }

    final isDesktop =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop;
    final child = _SyncStatusSheet(entries: entries);

    if (isDesktop) {
      await showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: child,
          ),
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => child,
    );
  }

  _SyncVisual _visualFor(BuildContext context, SyncIndicatorState state) {
    final l10n = AppLocalizations.of(context)!;

    switch (state) {
      case SyncIndicatorState.synced:
        return _SyncVisual(
          icon: Icons.cloud_done_outlined,
          color: Colors.green,
          label: l10n.syncSynced,
        );
      case SyncIndicatorState.syncing:
        return _SyncVisual(
          icon: Icons.sync,
          color: Theme.of(context).colorScheme.primary,
          label: l10n.syncInProgress,
        );
      case SyncIndicatorState.pending:
        return _SyncVisual(
          icon: Icons.cloud_queue_outlined,
          color: Colors.orange,
          label: l10n.syncPending,
        );
      case SyncIndicatorState.failed:
        return _SyncVisual(
          icon: Icons.cloud_off_outlined,
          color: Colors.red,
          label: l10n.syncFailed,
        );
    }
  }
}

class _SyncStatusSheet extends StatelessWidget {
  const _SyncStatusSheet({required this.entries});

  final List<SyncQueueData> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pendingEntries = entries
        .where((entry) => entry.status == SyncQueueStatus.pending)
        .toList();
    final failedEntries = entries
        .where((entry) => entry.status == SyncQueueStatus.failed)
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.syncStatusTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            if (entries.isEmpty)
              Text(
                l10n.noSyncItems,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else ...[
              if (pendingEntries.isNotEmpty) ...[
                Text('${l10n.pendingItems}: ${pendingEntries.length}'),
                const SizedBox(height: AppSpacing.sm),
                ...pendingEntries.map((entry) => _SyncEntryTile(entry: entry)),
                const SizedBox(height: AppSpacing.md),
              ],
              if (failedEntries.isNotEmpty) ...[
                Text('${l10n.failedItems}: ${failedEntries.length}'),
                const SizedBox(height: AppSpacing.sm),
                ...failedEntries.map((entry) => _SyncEntryTile(entry: entry)),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.icon(
                onPressed: () async {
                  await GetIt.I<SyncService>().processQueue();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.sync),
                label: Text(l10n.retrySync),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncEntryTile extends StatelessWidget {
  const _SyncEntryTile({required this.entry});

  final SyncQueueData entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        title: Text('${entry.targetTableName} #${entry.recordId}'),
        subtitle: Text(
          '${entry.operation.name.toUpperCase()} • retries: ${entry.retryCount}',
        ),
      ),
    );
  }
}

class _SyncBadge extends StatelessWidget {
  const _SyncBadge({required this.count, required this.isError});

  final int count;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isError ? Colors.red : Colors.orange,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        count.toString(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SyncVisual {
  const _SyncVisual({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;
}
