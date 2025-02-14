import 'package:cloud_firestore/cloud_firestore.dart';
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
  Stream<List<ChatMessage>> getChatMessages(String chatRoomId, int pageSize) {
    final models = _dataSource.getChatMessages(chatRoomId, pageSize).map((snapshot) =>
        snapshot.docs
            .map((doc) => ChatMessageModel.fromJson(doc.id, doc.data())));

    return models
        .map((data) => data.map((element) => element.toEntity()).toList());
  }

  @override
  Future<List<ChatMessage>> fetchMoreMessages(String chatRoomId, DateTime last) {
    return _dataSource
        .fetchMoreMessages(chatRoomId, Timestamp.fromDate(last))
        .then((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromJson(doc.id, doc.data()))
        .map((e) => e.toEntity()).toList());
  }

  @override
  Future<String> createChatRoom(String otherUserId, String senderId, String productID) {
    return _dataSource.createChatRoom(otherUserId, senderId, productID);
  }

  @override
  Future<void> sendMessage(
      String chatRoomId, String type, String content, String senderId) async {
    await _dataSource.sendMessage(chatRoomId, type, content, senderId);
  }

  @override
  Future<void> markChatAsRead(String chatRoomId, String userId) async {
    await _dataSource.markChatAsRead(chatRoomId, userId);
  }

  @override
  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    await _dataSource.deleteMessage(chatRoomId, messageId);
  }
}
