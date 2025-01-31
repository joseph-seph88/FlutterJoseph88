import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/domain/repositories/chat_repository.dart';

class GetChatRoomsUseCase {
  final ChatRepository _repository;

  GetChatRoomsUseCase(this._repository);

  Stream<List<ChatRoom>> call(String userId) {
    return _repository.getChatRooms(userId);
  }
}

class GetChatMessagesUseCase {
  final ChatRepository _repository;

  GetChatMessagesUseCase(this._repository);

  Stream<List<ChatMessage>> call(String chatRoomId) {
    return _repository.getChatMessages(chatRoomId);
  }
}