import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/providers.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_input.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_list.dart';

class ChatRoomScreen extends ConsumerWidget {
  final String? chatRoomId;
  final String otherUserId;

  const ChatRoomScreen(
      {super.key, required this.chatRoomId, required this.otherUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = 'a';

    if (chatRoomId != null) {
      final markChatAsReadUseCase = ref.read(markChatAsReadUseCaseProvider);
      markChatAsReadUseCase(chatRoomId!, userId);
    }

    return Scaffold(
      appBar: AppBar(title: Text(otherUserId)),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(chatRoomId: chatRoomId, userId: userId),
          ),
          ChatMessageInput(chatRoomId: chatRoomId, otherUserId: otherUserId),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
