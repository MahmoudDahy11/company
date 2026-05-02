class WorkerProduction {
  const WorkerProduction({
    required this.id,
    required this.workerId,
    required this.date,
    required this.stitchCount,
    this.notes,
    required this.dailyEarnings,
  });

  final int id;
  final int workerId;
  final DateTime date;
  final int stitchCount;
  final String? notes;
  final double dailyEarnings;
}
