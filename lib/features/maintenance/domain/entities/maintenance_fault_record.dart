class MaintenanceFaultRecord {
  const MaintenanceFaultRecord({
    required this.id,
    required this.machineName,
    required this.faultName,
    required this.cost,
    required this.totalCost,
    required this.createdAt,
  });

  final int id;
  final String machineName;
  final String faultName;
  final double cost;
  final double totalCost;
  final DateTime createdAt;
}
