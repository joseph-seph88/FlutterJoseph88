enum ChatMessageType {
  text, image, video, deleted,
}

class ChatMessage {
  final String id;
  final String senderId;
  final ChatMessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.type,
    required this.content,
    required this.sentTime,
  });
}