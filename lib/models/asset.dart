class Asset {
  final String id;
  final String name;
  final String condition; // e.g. "Good", "Broken", "Needs Repair"
  final String roomId;

  Asset({
    required this.id,
    required this.name,
    required this.condition,
    required this.roomId,
  });
}
