import 'package:o2/domain/entities/chat_room.dart';

abstract interface class ChatRepository {
  Stream<List<ChatRoom>> getChatRoomList(String userId);
}