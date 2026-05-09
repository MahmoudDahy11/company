import 'package:flutter/material.dart';

import 'absent_days_form.dart';
import 'advance_form.dart';
import 'deduction_form.dart';
import 'production_form.dart';
import 'stitch_rate_form.dart';
import 'worker_name_form.dart';
import 'workers_adaptive_sheet.dart';

Future<String?> showWorkerNameSheet(BuildContext context) {
  return showAdaptiveWorkersSheet<String>(
    context: context,
    child: const WorkerNameForm(),
  );
}

Future<double?> showStitchRateSheet(BuildContext context) {
  return showAdaptiveWorkersSheet<double>(
    context: context,
    child: const StitchRateForm(),
  );
}

Future<ProductionFormResult?> showProductionSheet(
  BuildContext context, {
  ProductionFormResult? initialValue,
}) {
  return showAdaptiveWorkersSheet<ProductionFormResult>(
    context: context,
    child: ProductionForm(initialValue: initialValue),
  );
}

Future<AdvanceFormResult?> showAdvanceSheet(
  BuildContext context, {
  AdvanceFormResult? initialValue,
}) {
  return showAdaptiveWorkersSheet<AdvanceFormResult>(
    context: context,
    child: AdvanceForm(initialValue: initialValue),
  );
}

Future<DeductionFormResult?> showDeductionSheet(BuildContext context) {
  return showAdaptiveWorkersSheet<DeductionFormResult>(
    context: context,
    child: const DeductionForm(),
  );
}

Future<int?> showAbsentDaysSheet(
  BuildContext context, {
  required int initialValue,
}) {
  return showAdaptiveWorkersSheet<int>(
    context: context,
    child: AbsentDaysForm(initialValue: initialValue),
  );
}
