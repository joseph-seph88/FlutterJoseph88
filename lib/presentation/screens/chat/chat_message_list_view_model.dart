import 'dart:async';
import 'dart:io';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/entities/product.dart';
import 'package:o2/domain/entities/user_entity.dart';
import 'package:o2/domain/usecases/chat_use_case.dart';
import 'package:o2/domain/usecases/map_use_case.dart';
import 'package:o2/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:o2/domain/usecases/user_use_case.dart';
import 'package:o2/presentation/providers/map_provider.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/providers/providers.dart';

class ChatMessageListViewModel extends StateNotifier<List<ChatMessage>> {
  final Ref ref;
  final String? chatRoomId;
  final GetChatMessagesUseCase getChatMessagesUseCase;
  final FetchMoreMessagesUseCase fetchMoreMessagesUseCase;
  final CreateChatRoomUseCase createChatRoomUseCase;
  final SendChatMessageUseCase sendChatMessageUseCase;
  final SendChatImageUseCase sendChatImageUseCase;
  final MarkChatAsReadUseCase markChatAsReadUseCase;
  final DeleteChatMessageUseCase deleteChatMessageUseCase;
  final GetUserDataUseCase getUserDataUseCase;
  final GetProductDetailUseCase getProductDetailUseCase;
  final MapUseCase mapUseCase;
  StreamSubscription? _subscription;

  ChatMessageListViewModel(
    this.ref,
    this.chatRoomId,
    this.getChatMessagesUseCase,
    this.fetchMoreMessagesUseCase,
    this.createChatRoomUseCase,
    this.sendChatMessageUseCase,
    this.sendChatImageUseCase,
    this.markChatAsReadUseCase,
    this.deleteChatMessageUseCase,
    this.getUserDataUseCase,
    this.getProductDetailUseCase,
    this.mapUseCase,
  ) : super([]) {
    _listenChatMessageStream(20);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _listenChatMessageStream(int pageSize) {
    _subscription?.cancel();
    if (chatRoomId == null) {
      state = [];
      return;
    }

    _subscription = getChatMessagesUseCase(chatRoomId!, pageSize).listen(
      (messages) {
        if (state.isEmpty || state.first.id == messages.first.id) {
          state = messages;
        } else {
          state = [messages.first, ...state];
          _listenChatMessageStream(state.length);
        }
      },
      onError: (e, stackTrace) {
        state = [];
      },
    );
  }

  Future<void> fetchMoreMessages() async {
    if (chatRoomId == null || state.isEmpty) {
      state = [];
      return;
    }

    final newMessages =
        await fetchMoreMessagesUseCase(chatRoomId!, state.last.sentTime);
    state = [...state, ...newMessages];

    _listenChatMessageStream(state.length);
  }

  void markChatAsRead(String chatRoomId, String userId) {
    markChatAsReadUseCase(chatRoomId, userId);
  }

  Future<String?> sendMessage({
    required String? chatRoomId,
    required String senderId,
    required String otherUserId,
    required String productId,
    required String message,
    required File? image,
  }) async {
    String? roomId;

    if (message.isNotEmpty || image != null) {
      roomId = chatRoomId ??
          await createChatRoomUseCase(otherUserId, senderId, productId);

      await Future.wait([
        Future(() async {
          if (message.isNotEmpty) {
            await sendChatMessageUseCase(
                roomId!, ChatMessageType.text, message, senderId);
          }
        }),
        Future(() async {
          if (image != null) {
            await sendChatImageUseCase(
              roomId!,
              ChatMessageType.image,
              image.path,
              senderId,
            );
          }
        }),
      ]);
    }

    return roomId;
  }

  Future<void> deleteMessage(String messageId) async {
    if (chatRoomId == null) return;

    try {
      await deleteChatMessageUseCase(chatRoomId!, messageId);
    } catch (e) {
      state = [];
    }
  }

  Future<UserEntity?> getOtherUserData(String userId) {
    return getUserDataUseCase(userId);
  }

  Future<Product?> getProductDetail(String productId) {
    return getProductDetailUseCase.execute(productId);
  }

  Future<String?> getAddress(String content) async {
    var latLng = content.split(' ').map((e) => double.tryParse(e));
    if (latLng.contains(null)) {
      final target = NaverMapViewOptions.seoulCityHall.target;
      latLng = [target.latitude, target.longitude];
    }

    final place = await mapUseCase
        .transPositionToAddress(NLatLng(latLng.first!, latLng.last!));
    return place?.street;
  }
}

final chatMessageListViewModelProvider = StateNotifierProvider.autoDispose
    .family<ChatMessageListViewModel, List<ChatMessage>, String?>(
  (ref, chatRoomId) {
    return ChatMessageListViewModel(
      ref,
      chatRoomId,
      ref.read(getChatMessagesUseCaseProvider),
      ref.read(fetchMoreMessagesUseCaseProvider),
      ref.read(createChatRoomUseCaseProvider),
      ref.read(sendChatMessageUseCaseProvider),
      ref.read(sendChatImageUseCaseProvider),
      ref.read(markChatAsReadUseCaseProvider),
      ref.read(deleteChatMessageUseCaseProvider),
      ref.read(getUserDataUseCaseProvider),
      ref.read(getProductDetailUseCaseProvider),
      ref.read(mapUseCaseProvider),
    );
  },
);
