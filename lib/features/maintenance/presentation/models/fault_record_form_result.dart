class FaultRecordFormResult {
  const FaultRecordFormResult({
    this.id,
    required this.machineName,
    required this.faultName,
    required this.cost,
    required this.totalCost,
  });

  final int? id;
  final String machineName;
  final String faultName;
  final double cost;
  final double totalCost;
}
