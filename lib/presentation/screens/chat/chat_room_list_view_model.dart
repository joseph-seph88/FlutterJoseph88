import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/domain/usecases/chat_use_case.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/providers.dart';
import 'package:o2/presentation/screens/chat/chat_list_screen.dart';

class ChatRoomListViewModel extends StateNotifier<AsyncValue<List<ChatRoom>>> {
  final Ref ref;
  final GetChatRoomsUseCase getChatRoomsUseCase;
  StreamSubscription? _subscription;

  ChatRoomListViewModel(this.ref, this.getChatRoomsUseCase)
      : super(const AsyncLoading()) {
    _listenChatRoomStream();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _listenChatRoomStream() {
    _subscription?.cancel();
    final userId = ref.read(authProvider)?.id;
    if (userId == null) {
      state = const AsyncData([]);
      return;
    }

    _subscription = getChatRoomsUseCase(userId).listen((data) {
      state = AsyncData(data);
    }, onError: (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    });
  }

  List<ChatRoom> getFilteredChatRooms(FilterType type) {
    final userId = ref.read(authProvider)?.id;
    if (userId == null) return [];


    return state.value?.where((element) {
      return switch (type) {
        FilterType.all => true,
        FilterType.selling => userId == element.seller,
        FilterType.buying => userId == element.buyer,
      };
    }).toList() ?? [];
  }
}

final chatRoomListViewModelProvider = StateNotifierProvider.autoDispose<
    ChatRoomListViewModel, AsyncValue<List<ChatRoom>>>((ref) {
  return ChatRoomListViewModel(ref, ref.read(getChatRoomsUseCaseProvider));
});
