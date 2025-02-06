import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/entities/chat_room.dart';

class ChatRoomModel {
  final String id;
  final String buyer;
  final String seller;
  final int unreadMessageCount;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final String lastMessageType;
  final String lastMessageSender;
  final String productID;

  ChatRoomModel({
    required this.id,
    required this.buyer,
    required this.seller,
    required this.unreadMessageCount,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageType,
    required this.lastMessageSender,
    required this.productID,
  });

  factory ChatRoomModel.fromJson(String id, Map<String, dynamic> json) {
    return ChatRoomModel(
      id: id,
      buyer: json['buyer'],
      seller: json['seller'],
      unreadMessageCount: json['unreadMessageCount'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      lastMessageType: json['lastMessageType'],
      lastMessageSender: json['lastMessageSender'],
      productID: json['productID'],
    );
  }

  ChatRoom toEntity() {
    return ChatRoom(
      id: id,
      buyer: buyer,
      seller: seller,
      unreadMessageCount: unreadMessageCount,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime.toDate(),
      lastMessageType: ChatMessageType.getByCode(lastMessageType),
      lastMessageSender: lastMessageSender,
      productID: productID,
    );
  }
}
