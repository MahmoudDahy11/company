class WorkerDeduction {
  const WorkerDeduction({
    required this.id,
    required this.workerId,
    required this.amount,
    required this.date,
    this.notes,
  });

  final int id;
  final int workerId;
  final double amount;
  final DateTime date;
  final String? notes;
}
