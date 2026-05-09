import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../domain/entities/dashboard_summary.dart';

class ClientsPieChart extends StatelessWidget {
  const ClientsPieChart({
    super.key,
    required this.points,
    required this.currency,
  });

  final List<DashboardPiePoint> points;
  final NumberFormat currency;

  static const _colors = [
    Color(0xFF0F766E),
    Color(0xFFEA580C),
    Color(0xFF2563EB),
    Color(0xFFDC2626),
    Color(0xFF059669),
    Color(0xFFD97706),
  ];

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noCurrentDebts));
    }

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 34,
              sections: List.generate(
                points.length,
                (i) => PieChartSectionData(
                  color: _colors[i % _colors.length],
                  value: points[i].value,
                  title: '',
                  radius: 70,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: ListView(
            children: List.generate(
              points.length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _colors[i % _colors.length],
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(points[i].label)),
                    const SizedBox(width: AppSpacing.sm),
                    Text(currency.format(points[i].value)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
