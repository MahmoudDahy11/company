import 'worker.dart';
import 'worker_advance.dart';
import 'worker_deduction.dart';
import 'worker_month_summary.dart';
import 'worker_production.dart';

class WorkerDetailsData {
  const WorkerDetailsData({
    required this.worker,
    required this.summary,
    required this.productions,
    required this.advances,
    required this.deductions,
  });

  final Worker worker;
  final WorkerMonthSummary summary;
  final List<WorkerProduction> productions;
  final List<WorkerAdvance> advances;
  final List<WorkerDeduction> deductions;
}
