import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/usecases/chat_use_case.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/image_picker_provider.dart';
import 'package:o2/presentation/providers/image_provider.dart';
import 'package:o2/presentation/providers/providers.dart';

class ChatMessageInputViewModel extends StateNotifier<bool> {
  final Ref ref;
  final CreateChatRoomUseCase createChatRoomUseCase;
  final SendChatMessageUseCase sendChatMessageUseCase;
  final SendChatImageUseCase sendChatImageUseCase;

  ChatMessageInputViewModel(
    this.ref,
    this.createChatRoomUseCase,
    this.sendChatMessageUseCase,
    this.sendChatImageUseCase,
  ) : super(false);

  Future<String?> sendMessage({
    required String? chatRoomId,
    required String otherUserId,
    required String productId,
    required String message,
  }) async {
    state = true;

    final senderId = ref.read(authProvider)?.id;
    if (senderId == null) return null;

    final selectedImage = ref.watch(selectedImageProvider);
    String? roomId;

    if (message.isNotEmpty || selectedImage != null) {
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
          if (selectedImage != null) {
            final imageUrl =
                await ref.read(uploadChatImageProvider)(roomId!, selectedImage);
            await sendChatImageUseCase(
              roomId,
              ChatMessageType.image,
              imageUrl,
              senderId,
            );
          }
        }),
      ]);
    }

    state = false;
    return roomId;
  }
}

final chatMessageInputViewModelProvider =
    StateNotifierProvider<ChatMessageInputViewModel, bool>((ref) {
  return ChatMessageInputViewModel(
    ref,
    ref.read(createChatRoomUseCaseProvider),
    ref.read(sendChatMessageUseCaseProvider),
    ref.read(sendChatImageUseCaseProvider),
  );
});
