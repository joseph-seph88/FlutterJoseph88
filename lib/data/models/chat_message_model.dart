import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:o2/domain/entities/chat_message.dart';

class ChatMessageModel {
  final String id;
  final String senderId;
  final String type;
  final String content;
  final Timestamp sentTime;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.type,
    required this.content,
    required this.sentTime,
  });

  factory ChatMessageModel.fromJson(String id, Map<String, dynamic> json) {
    return ChatMessageModel(
      id: id,
      senderId: json['senderId'],
      type: json['type'],
      content: json['content'],
      sentTime: json['sentTime'],
    );
  }

  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      senderId: senderId,
      type: ChatMessageType.getByCode(type),
      content: content,
      sentTime: sentTime.toDate(),
    );
  }
}
