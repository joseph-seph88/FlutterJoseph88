import 'package:o2/data/datasources/chat_remote_data_source.dart';
import 'package:o2/data/models/chat_message_model.dart';
import 'package:o2/data/models/chat_room_model.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _dataSource;

  ChatRepositoryImpl(this._dataSource);

  @override
  Stream<List<ChatRoom>> getChatRooms(String userId) {
    final models = _dataSource.getChatRooms(userId).map((snapshot) =>
        snapshot.docs.map((doc) => ChatRoomModel.fromJson(doc.id, doc.data())));

    return models
        .map((data) => data.map((element) => element.toEntity()).toList());
  }

  @override
  Stream<List<ChatMessage>> getChatMessages(String chatRoomId) {
    final models = _dataSource.getChatMessages(chatRoomId).map((snapshot) =>
        snapshot.docs
            .map((doc) => ChatMessageModel.fromJson(doc.id, doc.data())));

    return models
        .map((data) => data.map((element) => element.toEntity()).toList());
  }
}
