class Room {
  final int? id;
  final String name;
  final bool isOccupied; // Trạng thái phòng: đã thuê hay trống
  final String? assetIds; // Danh sách ID tài sản liên kết với phòng
  final String? imageUrl; // URL ảnh phòng
  final String? tenantId; // ID người thuê (nếu có)

  Room({
    this.id,
    required this.name,
    this.isOccupied = false,
    this.assetIds,
    this.imageUrl,
    this.tenantId,
  });

  factory Room.fromMap(Map<String, dynamic> map) => Room(
    id: map['id'],
    name: map['name'],
    isOccupied: map['isOccupied'],
    assetIds: map['assetIds'] ?? '',
    imageUrl: map['image_url'] ?? '',
    tenantId: map['tenantId'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'isOccupied': isOccupied,
    'assetIds': assetIds,
    'image_url': imageUrl,
    'tenantId': tenantId,
  };
}
