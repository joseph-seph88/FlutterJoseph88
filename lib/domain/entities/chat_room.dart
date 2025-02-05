import 'package:o2/domain/entities/chat_message.dart';

class ChatRoom {
  final String id;
  final String buyer;
  final String seller;
  final int unreadMessageCount;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final ChatMessageType? lastMessageType;
  final String? lastMessageSender;
  final String? productID;

  ChatRoom({
    required this.id,
    required this.buyer,
    required this.seller,
    required this.unreadMessageCount,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageType,
    this.lastMessageSender,
    this.productID,
  });
}