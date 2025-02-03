import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/utils/date_util.dart';
import 'package:o2/domain/entities/chat_room.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final String userId;

  const ChatRoomTile({super.key, required this.chatRoom, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(),
      title: Row(
        children: [
          Text(
            userId == chatRoom.buyer ? chatRoom.seller : chatRoom.buyer,
            maxLines: 1,
          ),
          SizedBox(width: 12),
          Text(
            chatRoom.lastMessageTime?.toElapsedTimeString() ?? '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: Text(chatRoom.lastMessage ?? '', maxLines: 1),
      trailing: userId == chatRoom.lastMessageSender ||
              chatRoom.unreadMessageCount == 0
          ? null
          : Badge.count(count: chatRoom.unreadMessageCount),
      onTap: () => context.push('/chats/chat_room', extra: {
        'chatRoomId': chatRoom.id,
        'otherUserId': userId == chatRoom.buyer ? chatRoom.seller : chatRoom.buyer,
      }),
    );
  }
}
