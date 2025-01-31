import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/repositories/chat_repository_impl.dart';
import 'package:o2/domain/entities/chat_message.dart';
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

final chatMessageProvider =
    StateNotifierProvider<ChatMessageNotifier, List<ChatMessage>>(
  (ref) => ChatMessageNotifier(),
);

class ChatMessageNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessageNotifier()
      : super([
          ChatMessage(
            id: '0',
            senderId: 'b',
            type: ChatMessageType.text,
            content: 'hi',
            sentTime: DateTime(2025, 1, 26),
          ),
          ChatMessage(
            id: '1',
            senderId: 'b',
            type: ChatMessageType.text,
            content: '안녕하세요?',
            sentTime: DateTime(2025, 1, 26),
          ),
          ChatMessage(
            id: '2',
            senderId: 'a',
            type: ChatMessageType.text,
            content: 'hello',
            sentTime: DateTime.now(),
          ),
          ChatMessage(
            id: '3',
            senderId: 'b',
            type: ChatMessageType.text,
            content: 'zzz',
            sentTime: DateTime.now(),
          ),
        ]);
}
