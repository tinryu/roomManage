class Tenant {
  final int? id;
  final String name;
  final String phone;
  final String? email;
  final DateTime checkIn;
  final DateTime? checkOut;

  Tenant({
    this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.checkIn,
    this.checkOut,
  });
  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      checkIn: DateTime.parse(map['checkin']),
      checkOut: map['checkout'] is String
          ? DateTime.parse(map['checkout'])
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'checkin': checkIn.toIso8601String(),
      'checkout': checkOut?.toIso8601String(),
    };
  }

  Tenant copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    DateTime? checkIn,
    DateTime? checkOut,
  }) {
    return Tenant(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
    );
  }
}
