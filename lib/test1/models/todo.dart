import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String content;
  final bool isDone;
  final DateTime timestamp;

  const Todo({
    required this.id,
    required this.title,
    required this.content,
    required this.isDone,
    required this.timestamp,
  });

  factory Todo.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      isDone: data['isDone'] ?? false,
      timestamp: data['timestamp'] is Timestamp
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.parse(data['timestamp'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'isDone': isDone,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    String? content,
    bool? isDone,
    DateTime? timestamp,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [id, title, content, isDone, timestamp];
}
