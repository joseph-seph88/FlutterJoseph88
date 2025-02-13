import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/domain/entities/user_entity.dart';
import 'package:o2/domain/usecases/chat_use_case.dart';
import 'package:o2/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:o2/domain/usecases/user_use_case.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/providers/providers.dart';
import 'package:o2/presentation/screens/chat/chat_list_screen.dart';

class ChatRoomListViewModel extends StateNotifier<AsyncValue<List<ChatRoom>>> {
  final Ref ref;
  final GetChatRoomsUseCase getChatRoomsUseCase;
  final GetUserDataUseCase getUserDataUseCase;
  final GetProductDetailUseCase getProductDetailUseCase;
  StreamSubscription? _subscription;

  ChatRoomListViewModel(
    this.ref,
    this.getChatRoomsUseCase,
    this.getUserDataUseCase,
    this.getProductDetailUseCase,
  ) : super(const AsyncLoading()) {
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
        }).toList() ??
        [];
  }

  Future<UserEntity?> getOtherUserData(String userId) {
    return getUserDataUseCase(userId);
  }

  Future<String?> getProductImage(String? productId) async {
    if (productId == null) return null;
    return getProductDetailUseCase
        .execute(productId)
        .then((value) => value?.images.firstOrNull);
  }
}

final chatRoomListViewModelProvider = StateNotifierProvider.autoDispose<
    ChatRoomListViewModel, AsyncValue<List<ChatRoom>>>((ref) {
  return ChatRoomListViewModel(
    ref,
    ref.read(getChatRoomsUseCaseProvider),
    ref.read(getUserDataUseCaseProvider),
    ref.read(getProductDetailUseCaseProvider),
  );
});
