class Tenant {
  final int? id;
  final int? roomId;
  final String name;
  final String phone;
  final String? email;
  final DateTime checkIn;
  final DateTime? checkOut;
  final String? imageUrl;

  Tenant({
    this.id,
    this.roomId,
    required this.name,
    required this.phone,
    this.email,
    required this.checkIn,
    this.checkOut,
    this.imageUrl,
  });
  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id'],
      roomId: map['room_id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      checkIn: DateTime.parse(map['checkin']),
      checkOut: map['checkout'] is String
          ? DateTime.parse(map['checkout'])
          : null,
      imageUrl: map['image_url'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room_id': roomId,
      'name': name,
      'phone': phone,
      'email': email,
      'checkin': checkIn.toIso8601String(),
      'checkout': checkOut?.toIso8601String(),
      'image_url': imageUrl,
    };
  }

  Tenant copyWith({
    int? id,
    int? roomId,
    String? name,
    String? phone,
    String? email,
    DateTime? checkIn,
    DateTime? checkOut,
    String? imageUrl,
  }) {
    return Tenant(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
