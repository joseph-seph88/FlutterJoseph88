import 'package:flutter/material.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_room_tile.dart';

class ChatRoomList extends StatelessWidget {
  final List<ChatRoom> chatRoomList;
  final String userId;

  const ChatRoomList({super.key, required this.chatRoomList, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (chatRoomList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 48),
            const SizedBox(height: 16),
            Text('채팅방이 없습니다', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: chatRoomList.length,
      itemBuilder: (context, index) {
        final chatRoom = chatRoomList[index];
        return ChatRoomTile(chatRoom: chatRoom, userId: userId);
      },
    );
  }
}
