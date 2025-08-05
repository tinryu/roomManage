class Payment {
  final int? id;
  final String tenantId;
  final String roomId;
  final double amount;
  final bool isPaid;
  final String type; // e.g., "rent", "utilities"
  final DateTime datetime;

  Payment({
    this.id,
    required this.tenantId,
    required this.roomId,
    required this.amount,
    required this.isPaid,
    required this.type,
    required this.datetime,
  });

  factory Payment.fromMap(Map<String, dynamic> map) => Payment(
    id: map['id'],
    tenantId: map['tenantId'],
    roomId: map['roomId'],
    amount: map['amount'],
    isPaid: map['isPaid'],
    type: map['type'] ?? 'rent', // Default to 'rent' if not provided
    datetime: DateTime.parse(map['date']),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'tenantId': tenantId,
    'roomId': roomId,
    'amount': amount,
    'isPaid': isPaid,
    'type': type,
    'date': datetime.toIso8601String(),
  };
}
