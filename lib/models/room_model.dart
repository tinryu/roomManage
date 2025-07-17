class Room {
  final String id;
  final String name;
  final String destription;
  final String content;
  final String imageUrl; // Default image
  final String status;
  final String type;

  Room({
    required this.id,
    required this.name,
    required this.destription,
    required this.content,
    required this.imageUrl,
    required this.status,
    required this.type,
  });

  factory Room.fromJson(Map<String, dynamic> item) {
    return Room(
      id: item['id'].toString(),
      name: item['name'] ?? '',
      destription: item['destription'] ?? '',
      content: item['content'] ?? '',
      imageUrl: item['imageUrl'] ?? 'assets/images/room.png',
      status: item['status'] ?? '',
      type: item['type'] ?? '',
    );
  }
}
