class ChatModel {
  final String message;
  final bool isMine;
  final DateTime timestamp;

  ChatModel({
    required this.message,
    required this.isMine,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'isMine': isMine,
      'timestamp': timestamp,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> chatData) {
    return ChatModel(
      message: chatData['message'],
      isMine: chatData['isMine'],
      timestamp: chatData['timestamp'],
    );
  }
}
