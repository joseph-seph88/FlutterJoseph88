import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/repositories/chat_repository_impl.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/domain/usecases/chat_usecases.dart';

final chatRoomProvider =
    StateNotifierProvider<ChatRoomNotifier, List<ChatRoom>>(
  (ref) => ChatRoomNotifier(ref),
);

class ChatRoomNotifier extends StateNotifier<List<ChatRoom>> {
  final Ref ref;

  ChatRoomNotifier(this.ref) : super([]) {
    _fetchChatRooms();
  }

  void _fetchChatRooms() {
    final userId = 'a';
    final getChatRoomListUseCase =
        GetChatRoomListUseCase(ref.read(chatRepositoryProvider));

    getChatRoomListUseCase(userId).listen((data) {
      state = data;
    });
  }
}
