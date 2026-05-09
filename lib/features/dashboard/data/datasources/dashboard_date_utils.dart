import '../../domain/entities/financial_filter.dart';

({DateTime start, DateTime end}) monthRange(DateTime month) {
  final start = DateTime(month.year, month.month);
  final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
  return (start: start, end: end);
}

({DateTime start, DateTime end}) financialRange(
  DateTime month,
  FinancialFilter filter,
) {
  final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
  switch (filter) {
    case FinancialFilter.last3Months:
      return (start: DateTime(month.year, month.month - 2), end: end);
    case FinancialFilter.last6Months:
      return (start: DateTime(month.year, month.month - 5), end: end);
    case FinancialFilter.lastYear:
      return (start: DateTime(month.year, month.month - 11), end: end);
  }
}
