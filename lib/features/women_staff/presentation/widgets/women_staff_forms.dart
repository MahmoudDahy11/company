import 'package:flutter/material.dart';

import '../../../../core/utils/app_breakpoints.dart';
import '../../../../core/utils/app_spacing.dart';

class StaffFormResult {
  const StaffFormResult({required this.name, required this.monthlySalary});

  final String name;
  final double monthlySalary;
}

class StaffAdvanceFormResult {
  const StaffAdvanceFormResult({
    required this.amount,
    required this.date,
    this.notes,
  });

  final double amount;
  final DateTime date;
  final String? notes;
}

Future<T?> showAdaptiveStaffSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  if (MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop) {
    return showDialog<T>(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: child,
        ),
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (context) => child,
  );
}

class StaffSheetScaffold extends StatelessWidget {
  const StaffSheetScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
