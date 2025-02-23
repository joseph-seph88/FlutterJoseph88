import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String? id;
  final String content;
  final Timestamp makeTime;
  final Timestamp? finishTime;
  final bool isProgress;

  Schedule({
    this.id,
    required this.content,
    required this.makeTime,
    this.finishTime,
    this.isProgress = true,
  });

  Schedule copyWith({
    String? id,
    String? content,
    Timestamp? makeTime,
    Timestamp? finishTime,
    bool? isProgress,
  }) {
    return Schedule(
      id: id ?? this.id,
      content: content ?? this.content,
      makeTime: makeTime ?? this.makeTime,
      finishTime: finishTime ?? this.finishTime,
      isProgress: isProgress ?? this.isProgress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'makeTime': makeTime,
      'finishTime': finishTime,
      'isProgress': isProgress,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> data) {
    return Schedule(
      id: data['id'],
      content: data['content'],
      makeTime: data['makeTime'],
      finishTime: data['finishTime'],
      isProgress: data['isProgress'],
    );
  }
}
