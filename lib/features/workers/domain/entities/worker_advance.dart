class WorkerAdvance {
  const WorkerAdvance({
    required this.id,
    required this.workerId,
    required this.amount,
    required this.date,
    this.notes,
    required this.carriedOver,
  });

  final int id;
  final int workerId;
  final double amount;
  final DateTime date;
  final String? notes;
  final bool carriedOver;
}
