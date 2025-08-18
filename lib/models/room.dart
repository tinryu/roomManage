class Room {
  final int? id;
  final String name;
  final bool isOccupied; // Trạng thái phòng: đã thuê hay trống
  final String? assetId; // Danh sách ID tài sản liên kết với phòng
  final String? imageUrl; // URL ảnh phòng
  final String? tenantId; // ID người thuê (nếu có)

  Room({
    this.id,
    required this.name,
    this.isOccupied = false,
    this.assetId,
    this.imageUrl,
    this.tenantId,
  });

  factory Room.fromMap(Map<String, dynamic> map) => Room(
    id: map['id'],
    name: map['name'],
    isOccupied: map['isOccupied'],
    assetId: map['assetId'] ?? '',
    imageUrl: map['image_url'] ?? '',
    tenantId: map['tenantId'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'isOccupied': isOccupied,
    'assetId': assetId,
    'image_url': imageUrl,
    'tenantId': tenantId,
  };

  Room copyWith({
    int? id,
    String? name,
    bool? isOccupied,
    String? assetId,
    String? imageUrl,
    String? tenantId,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      isOccupied: isOccupied ?? this.isOccupied,
      assetId: assetId ?? this.assetId,
      imageUrl: imageUrl ?? this.imageUrl,
      tenantId: tenantId ?? this.tenantId,
    );
  }

  @override
  String toString() {
    return 'Room(id: $id, name: $name, isOccupied: $isOccupied, assetId: $assetId, imageUrl: $imageUrl, tenantId: $tenantId)';
  }
}
