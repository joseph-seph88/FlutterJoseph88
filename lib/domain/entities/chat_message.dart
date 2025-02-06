enum ChatMessageType {
  text('text'),
  image('image'),
  video('video'),
  location('location'),
  deleted('deleted');

  final String code;

  const ChatMessageType(this.code);

  factory ChatMessageType.getByCode(String code) {
    return ChatMessageType.values.firstWhere(
      (value) => value.code == code,
      orElse: () => ChatMessageType.text,
    );
  }
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
