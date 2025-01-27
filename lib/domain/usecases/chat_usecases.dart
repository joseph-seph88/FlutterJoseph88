import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/domain/repositories/chat_repository.dart';

class GetChatRoomListUseCase {
  final ChatRepository _repository;

  GetChatRoomListUseCase(this._repository);

  Stream<List<ChatRoom>> call(String userId) {
    return _repository.getChatRoomList(userId);
  }
}