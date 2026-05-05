class StaffDeduction {
  const StaffDeduction({
    required this.id,
    required this.staffId,
    required this.amount,
    required this.date,
    this.notes,
  });

  final int id;
  final int staffId;
  final double amount;
  final DateTime date;
  final String? notes;
}
