import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/chat_provider.dart';

class ChatRoomListViewModel extends StateNotifier<AsyncValue<List<ChatRoom>>> {
  final Ref ref;

  ChatRoomListViewModel(this.ref) : super(const AsyncLoading()) {
    _loadChatRooms();
  }

  Future<void> _loadChatRooms() async {
    final userId = ref.read(authProvider)?.id;
    if (userId == null) {
      state = const AsyncData([]);
      return;
    }

    try {
      state = ref.watch(chatRoomStreamProvider);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

final chatRoomListViewModelProvider = StateNotifierProvider.autoDispose<
    ChatRoomListViewModel, AsyncValue<List<ChatRoom>>>((ref) {
  return ChatRoomListViewModel(ref);
});
