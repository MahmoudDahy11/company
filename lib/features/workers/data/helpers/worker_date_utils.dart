DateTime monthStart(DateTime date) => DateTime(date.year, date.month);

DateTime dayStart(DateTime date) => DateTime(date.year, date.month, date.day);

({DateTime start, DateTime end}) monthRange(DateTime date) {
  final start = monthStart(date);
  final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  return (start: start, end: end);
}

bool isAfterMonth(DateTime value, DateTime target) {
  return value.year > target.year ||
      (value.year == target.year && value.month > target.month);
}
