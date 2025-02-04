import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/date_util.dart';
import 'package:o2/domain/entities/chat_message.dart';
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
          const SizedBox(width: 12),
          Text(
            chatRoom.lastMessageTime?.toElapsedTimeString() ?? '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: _buildContent(),
      trailing: userId == chatRoom.lastMessageSender ||
              chatRoom.unreadMessageCount == 0
          ? null
          : Badge.count(count: chatRoom.unreadMessageCount),
      onTap: () => context.push('/chats/chat_room', extra: {
        'chatRoomId': chatRoom.id,
        'otherUserId':
            userId == chatRoom.buyer ? chatRoom.seller : chatRoom.buyer,
      }),
    );
  }

  Widget _buildContent() {
    return switch (chatRoom.lastMessageType) {
      null ||
      ChatMessageType.text =>
        Text(chatRoom.lastMessage ?? '', maxLines: 1),
      ChatMessageType.image => const Row(
          children: [
            Icon(Icons.photo),
            SizedBox(width: 8),
            Text(
              '사진',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ChatMessageType.video => throw UnimplementedError(),
      ChatMessageType.deleted => const Row(
          children: [
            Icon(Icons.delete),
            SizedBox(width: 8),
            Text(
              '삭제된 메시지입니다.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
    };
  }
}
