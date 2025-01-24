class ChatRoom {
  final String id;
  final String buyer;
  final String seller;
  final int unreadMessageCount;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastMessageSender;

  ChatRoom({
    required this.id,
    required this.buyer,
    required this.seller,
    required this.unreadMessageCount,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSender,
  });
}