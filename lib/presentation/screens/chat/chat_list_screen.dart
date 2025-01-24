import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/chat_provider.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_room_list.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRooms = ref.watch(chatRoomProvider);
    final userId = 'buyer';

    return Scaffold(
      appBar: AppBar(title: Text('채팅')),
      body: Column(
        children: [
          // 필터 추가 예정
          Expanded(child: ChatRoomList(chatRoomList: chatRooms, userId: userId)),
        ],
      ),
    );
  }
}
