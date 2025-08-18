class Payment {
  final int? id;
  final String? tenantId;
  final String? roomId;
  final int amount;
  final bool isPaid;
  final String? type; // e.g., "rent", "utilities"
  final DateTime datetime;

  Payment({
    this.id,
    this.tenantId,
    this.roomId,
    required this.amount,
    required this.isPaid,
    this.type,
    required this.datetime,
  });

  factory Payment.fromMap(Map<String, dynamic> map) => Payment(
    id: map['id'],
    tenantId: map['tenantid'] ?? '',
    roomId: map['roomid'] ?? '',
    amount: map['amount'],
    isPaid: map['isPaid'],
    type: map['type'], // Default to 'rent' if not provided
    datetime: map['datetime'] is String
        ? DateTime.parse(map['datetime'])
        : (map['datetime'] as DateTime? ?? DateTime.now()), // fallback if null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'tenantid': tenantId,
    'roomid': roomId,
    'amount': amount,
    'isPaid': isPaid,
    'type': type,
    'datetime': datetime.toIso8601String(),
  };
}
