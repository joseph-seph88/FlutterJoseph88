import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/chat_provider.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_input.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_list.dart';

class ChatRoomScreen extends ConsumerWidget {
  final String chatRoomId;

  const ChatRoomScreen({super.key, required this.chatRoomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = 'a';
    final chatRoom = ref
        .read(chatRoomProvider)
        .firstWhere((chatRoom) => chatRoom.id == chatRoomId);
    final otherUserId =
        chatRoom.buyer == userId ? chatRoom.seller : chatRoom.buyer;

    return Scaffold(
      appBar: AppBar(title: Text(otherUserId)),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(chatRoomId: chatRoomId, userId: userId),
          ),
          ChatMessageInput(chatRoomId),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
