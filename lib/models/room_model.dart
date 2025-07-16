class Room {
  final String id;
  final String name;
  final String destription;
  final String status;
  final String type;

  Room({
    required this.id,
    required this.name,
    required this.destription,
    required this.status,
    required this.type,
  });

  factory Room.fromJson(Map<String, dynamic> item) {
    return Room(
      id: item['id'].toString(),
      name: item['name'] ?? '',
      destription: item['destription'] ?? '',
      status: item['status'] ?? '',
      type: item['type'] ?? '',
    );
  }
}
