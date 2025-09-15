class Activity {
  final int? id;
  final String userid;
  final String action; //e.q: check-in, check-out, payment
  final DateTime timestamp;

  Activity({
    this.id,
    required this.userid,
    required this.action,
    required this.timestamp,
  });
  factory Activity.fromMap(Map<String, dynamic> map) => Activity(
    id: map['id'],
    userid: map['userid'] ?? '', // or throw if it's truly required
    action: map['action'] ?? '',
    timestamp: map['timestamp'] is String
        ? DateTime.parse(map['timestamp'])
        : (map['timestamp'] as DateTime? ?? DateTime.now()), // fallback if null
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'userid': userid,
    'action': action,
    'timestamp': timestamp.toIso8601String(),
  };
}
