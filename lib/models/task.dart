class Task {
  final int? id;
  final DateTime createdAt;
  final String title;
  final String? context;
  final String? imageUrl;
  final DateTime? dueAt;

  Task({
    this.id,
    required this.createdAt,
    required this.title,
    this.context,
    this.imageUrl,
    this.dueAt,
  });

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    createdAt: map['created_at'] is String
        ? DateTime.parse(map['created_at'])
        : (map['created_at'] as DateTime? ?? DateTime.now()),
    title: map['title'] ?? '',
    context: map['context'],
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
    'image_url': imageUrl,
    'due_at': dueAt?.toIso8601String(),
  };

  Task copyWith({
    int? id,
    DateTime? createdAt,
    String? title,
    String? context,
    String? imageUrl,
    DateTime? dueAt,
  }) {
    return Task(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      context: context ?? this.context,
      imageUrl: imageUrl ?? this.imageUrl,
      dueAt: dueAt ?? this.dueAt,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, createdAt: $createdAt, title: $title, context: $context, imageUrl: $imageUrl, dueAt: $dueAt)';
  }
}
