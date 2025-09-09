class Asset {
  final int id;
  final int? roomId; // Make roomId nullable
  final String name;
  final String condition; // e.g. "Good", "Broken", "Needs Repair"
  final String? imageUrl;
  final int quantity;
  final DateTime createdAt;

  Asset({
    required this.id,
    this.roomId, // Now nullable, so no 'required' keyword
    required this.name,
    required this.condition,
    this.imageUrl,
    required this.quantity,
    required this.createdAt,
  });

  factory Asset.fromMap(Map<String, dynamic> map) => Asset(
    id: map['id'] as int? ?? 0,
    roomId: map['room_id'] as int?,
    name: map['name'] as String? ?? 'Unnamed Asset',
    condition: map['condition'] as String? ?? 'Unknown',
    imageUrl: map['image_url'] as String?,
    quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    createdAt: map['created_at'] is String
        ? DateTime.tryParse(map['created_at']) ?? DateTime.now()
        : (map['created_at'] as DateTime? ?? DateTime.now()),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'room_id': roomId,
    'name': name,
    'condition': condition,
    'image_url': imageUrl,
    'quantity': quantity,
    'created_at': createdAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Asset && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Asset{id: $id, name: $name}';
  }
}
