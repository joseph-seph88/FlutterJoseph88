import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/domain/repositories/chat_repository.dart';
import 'package:o2/domain/repositories/image_repository.dart';

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

class CreateChatRoomUseCase {
  final ChatRepository _repository;

  CreateChatRoomUseCase(this._repository);

  Future<String> call(String otherUserId, String senderId, String productID) {
    return _repository.createChatRoom(otherUserId, senderId, productID);
  }
}

class SendChatMessageUseCase {
  final ChatRepository _repository;

  SendChatMessageUseCase(this._repository);

  Future<void> call(String chatRoomId, ChatMessageType type, String content,
      String senderId) async {
    await _repository.sendMessage(chatRoomId, type.code, content, senderId);
  }
}

class SendChatImageUseCase {
  final ChatRepository _chatRepository;
  final ImageRepository _imageRepository;

  SendChatImageUseCase(this._chatRepository, this._imageRepository);

  Future<void> call(String chatRoomId, ChatMessageType type, String path,
      String senderId) async {
    final imageURL = await _imageRepository.uploadImage(chatRoomId, path);
    await _chatRepository.sendMessage(chatRoomId, type.code, imageURL, senderId);
  }
}

class MarkChatAsReadUseCase {
  final ChatRepository _repository;

  MarkChatAsReadUseCase(this._repository);

  Future<void> call(String chatRoomId, String userId) async {
    await _repository.markChatAsRead(chatRoomId, userId);
  }
}

class DeleteChatMessageUseCase {
  final ChatRepository _repository;

  DeleteChatMessageUseCase(this._repository);

  Future<void> call(String chatRoomId, String messageId) async {
    await _repository.deleteMessage(chatRoomId, messageId);
  }
}
