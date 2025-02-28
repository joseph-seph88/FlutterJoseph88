import 'package:uuid/uuid.dart';

class ChatModel {
  final String id;
  final String? text;
  final DateTime timestamp;
  final bool isMine;
  final List<String?> imagePaths;

  ChatModel({
    String? id,
    this.text,
    DateTime? timestamp,
    required this.isMine,
    List<String?>? imagePaths,
  })  : id = id ?? Uuid().v4().substring(0, 8),
        timestamp = timestamp ?? DateTime.now(),
        imagePaths = imagePaths ?? [];
}
