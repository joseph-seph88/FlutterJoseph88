import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/providers.dart';

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
    final userId = ref.read(authProvider)?.id;
    if (userId == null) {
      state = [];
      return;
    }
    final getChatRoomsUseCase = ref.read(getChatRoomsUseCaseProvider);

    getChatRoomsUseCase(userId).listen((data) {
      state = data;
    });
  }
}

final chatMessageProvider =
    StateNotifierProvider.autoDispose<ChatMessageNotifier, List<ChatMessage>>(
  (ref) => ChatMessageNotifier(ref),
);

class ChatMessageNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref ref;

  ChatMessageNotifier(this.ref) : super([]);

  StreamSubscription fetchChatMessages(String chatRoomId) {
    final getChatMessagesUseCase = ref.read(getChatMessagesUseCaseProvider);

    return getChatMessagesUseCase(chatRoomId).listen((data) {
      state = data;
    });
  }
}
