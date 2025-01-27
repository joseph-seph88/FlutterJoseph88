import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:o2/domain/entities/chat_room.dart';

class ChatRoomModel {
  final String id;
  final String buyer;
  final String seller;
  final int unreadMessageCount;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSender;

  ChatRoomModel({
    required this.id,
    required this.buyer,
    required this.seller,
    required this.unreadMessageCount,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSender,
  });

  factory ChatRoomModel.fromJson(String id, Map<String, dynamic> json) {
    return ChatRoomModel(
      id: id,
      buyer: json['buyer'],
      seller: json['seller'],
      unreadMessageCount: json['unreadMessageCount'],
      lastMessage: json['lastMessage'],
      lastMessageTime: (json['lastMessageTime'] as Timestamp).toDate(),
      lastMessageSender: json['lastMessageSender'],
    );
  }

  ChatRoom toEntity() {
    return ChatRoom(
      id: id,
      buyer: buyer,
      seller: seller,
      unreadMessageCount: unreadMessageCount,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      lastMessageSender: lastMessageSender,
    );
  }
}
