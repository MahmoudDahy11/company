import 'package:flutter/material.dart';

import '../../../../core/utils/app_spacing.dart';

class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.width,
    required this.title,
    required this.child,
  });

  final double width;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              SizedBox(height: 260, child: child),
            ],
          ),
        ),
      ),
    );
  }
}
