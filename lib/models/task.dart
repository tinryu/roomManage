// ignore_for_file: non_constant_identifier_names
class Task {
  final int? id;
  final DateTime createdAt;
  final String title;
  final String? context;
  final int? status; //0:TODO,1:InProgress,2:Done
  final String? imageUrl;
  final DateTime? dueAt;

  Task({
    this.id,
    required this.createdAt,
    required this.title,
    this.context,
    this.status,
    this.imageUrl,
    this.dueAt,
  });

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    createdAt: map['created_at'] is String
        ? DateTime.parse(map['created_at'])
        : (map['created_at'] as DateTime? ?? DateTime.now()),
    title: map['title'] ?? '',
    context: map['context'] ?? '',
    status: map['status'] ?? 0,
    imageUrl: map['image_url'],
    dueAt: map['due_at'] == null
        ? null
        : (map['due_at'] is String
              ? DateTime.parse(map['due_at'])
              : map['due_at'] as DateTime),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'created_at': createdAt.toIso8601String(),
    'title': title,
    'context': context,
    'status': status,
    'image_url': imageUrl,
    'due_at': dueAt?.toIso8601String(),
  };

  Task copyWith({
    int? id,
    DateTime? createdAt,
    String? title,
    String? context,
    int? status,
    String? imageUrl,
    DateTime? dueAt,
  }) {
    return Task(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      context: context ?? this.context,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      dueAt: dueAt ?? this.dueAt,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, createdAt: $createdAt, title: $title, context: $context, status: $status, imageUrl: $imageUrl, dueAt: $dueAt)';
  }
}
