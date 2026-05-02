class StaffAdvance {
  const StaffAdvance({
    required this.id,
    required this.staffId,
    required this.amount,
    required this.date,
    this.notes,
    required this.carriedOver,
  });

  final int id;
  final int staffId;
  final double amount;
  final DateTime date;
  final String? notes;
  final bool carriedOver;
}
