import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../bloc/women_staff_cubit.dart';
import '../bloc/women_staff_state.dart';
import '../widgets/staff_list_header.dart';
import '../widgets/staff_list_table.dart';

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
            child: RefreshIndicator(
              onRefresh: () => context.read<WomenStaffCubit>().start(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StaffListHeader(state: state),
                    const SizedBox(height: AppSpacing.lg),
                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state.filteredItems.isEmpty)
                      Center(child: Text(l10n.noWomenStaffYet))
                    else
                      StaffListTable(items: state.filteredItems),
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
