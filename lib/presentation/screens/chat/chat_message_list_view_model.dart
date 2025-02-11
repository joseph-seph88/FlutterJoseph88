import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/usecases/chat_use_case.dart';
import 'package:o2/domain/usecases/map_use_case.dart';
import 'package:o2/presentation/providers/chat_provider.dart';
import 'package:o2/presentation/providers/providers.dart';

class ChatMessageListViewModel
    extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final Ref ref;
  final String? chatRoomId;
  final DeleteChatMessageUseCase deleteChatMessageUseCase;
  final MapUseCase mapUseCase;

  ChatMessageListViewModel(
    this.ref,
    this.chatRoomId,
    this.deleteChatMessageUseCase,
    this.mapUseCase,
  ) : super(const AsyncLoading()) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (chatRoomId == null) {
      state = const AsyncData([]);
      return;
    }

    try {
      state = ref.watch(chatMessageStreamProvider(chatRoomId!));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> deleteMessage(String messageId) async {
    if (chatRoomId == null) return;

    try {
      await deleteChatMessageUseCase(chatRoomId!, messageId);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<String?> getAddress(String content) async {
    var latLng = content.split(' ').map((e) => double.tryParse(e));
    if (latLng.contains(null)) {
      final target = NaverMapViewOptions.seoulCityHall.target;
      latLng = [target.latitude, target.longitude];
    }

    final place = await mapUseCase
        .transAddressFromGeo(NLatLng(latLng.first!, latLng.last!));
    return place?.street;
  }
}

final chatMessageListViewModelProvider = StateNotifierProvider.autoDispose
    .family<ChatMessageListViewModel, AsyncValue<List<ChatMessage>>, String?>(
  (ref, chatRoomId) {
    final deleteChatMessageUseCase = ref.read(deleteChatMessageUseCaseProvider);
    final mapUseCase = ref.read(mapUseCaseProvider);
    return ChatMessageListViewModel(
      ref,
      chatRoomId,
      deleteChatMessageUseCase,
      mapUseCase,
    );
  },
);
