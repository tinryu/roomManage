class Tenant {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final DateTime checkIn;
  final DateTime? checkOut;

  Tenant({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.checkIn,
    this.checkOut,
  });
}
