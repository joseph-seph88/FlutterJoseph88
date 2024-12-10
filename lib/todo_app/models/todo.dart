class Todo {
  final String? id;
  final String title;
  final String content;
  final bool isDone;
  final List<String>? comments;
  // final DateTime timestamp;

  const Todo({
    this.id,
    required this.title,
    required this.content,
    required this.isDone,
    this.comments,
    // required this.timestamp,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? content,
    bool? isDone,
    List<String>? comments,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isDone': isDone,
      'comments': comments ?? [],
      // 'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      title: map['title'],
      content: map['content'],
      isDone: map['isDone'] ?? false,
      comments: List<String>.from(map['comments'] ?? []),
      // timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
