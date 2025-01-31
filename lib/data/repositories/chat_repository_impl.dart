import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/datasources/chat_remote_data_source.dart';
import 'package:o2/data/models/chat_room_model.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/domain/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
    (ref) => ChatRepositoryImpl(ChatRemoteDataSourceImpl()));

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _dataSource;

  ChatRepositoryImpl(this._dataSource);

  @override
  Stream<List<ChatRoom>> getChatRoomList(String userId) {
    final models = _dataSource.getChatRoomList(userId).map((snapshot) =>
        snapshot.docs.map((doc) => ChatRoomModel.fromJson(doc.id, doc.data())));

    return models
        .map((data) => data.map((element) => element.toEntity()).toList());
  }
}
