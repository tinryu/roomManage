class Asset {
  final int id;
  final String roomid;
  final String name;
  final String condition; // e.g. "Good", "Broken", "Needs Repair"
  final String? imageUrl;
  final int quantity;
  final DateTime createdAt;

  Asset({
    required this.id,
    required this.roomid,
    required this.name,
    required this.condition,
    this.imageUrl,
    required this.quantity,
    required this.createdAt,
  });

  factory Asset.fromMap(Map<String, dynamic> map) => Asset(
    id: map['id'],
    roomid: map['roomid'],
    name: map['name'],
    condition: map['condition'],
    imageUrl: map['image_url'],
    quantity: map['quantity'],
    createdAt: map['created_at'] is String
        ? DateTime.parse(map['created_at'])
        : (map['created_at'] as DateTime? ??
              DateTime.now()), // fallback if null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'roomid': roomid,
    'name': name,
    'condition': condition,
    'image_url': imageUrl,
    'quantity': quantity,
    'created_at': createdAt.toIso8601String(),
  };
}
