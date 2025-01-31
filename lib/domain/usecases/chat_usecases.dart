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

class SendChatMessageUseCase {
  final ChatRepository _repository;

  SendChatMessageUseCase(this._repository);

  Future<void> call(String chatRoomId, String content, String senderId) async {
    await _repository.sendMessage(chatRoomId, content, senderId);
  }
}

class MarkChatAsReadUseCase {
  final ChatRepository _repository;

  MarkChatAsReadUseCase(this._repository);

  Future<void> call(String chatRoomId, String userId) async {
    await _repository.markChatAsRead(chatRoomId, userId);
  }
}