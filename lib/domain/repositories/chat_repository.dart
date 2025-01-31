import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/entities/chat_room.dart';

abstract interface class ChatRepository {
  Stream<List<ChatRoom>> getChatRooms(String userId);

  Stream<List<ChatMessage>> getChatMessages(String chatRoomId);
}