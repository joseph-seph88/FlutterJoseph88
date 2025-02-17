import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/date_util.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/domain/entities/user_entity.dart';
import 'package:o2/presentation/screens/chat/chat_room_list_view_model.dart';
import 'package:o2/presentation/widgets/profile_image.dart';

class ChatRoomTile extends ConsumerWidget {
  final ChatRoom chatRoom;
  final String userId;

  const ChatRoomTile({super.key, required this.chatRoom, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherUserID =
        userId == chatRoom.buyer ? chatRoom.seller : chatRoom.buyer;
    final viewModel = ref.read(chatRoomListViewModelProvider.notifier);
    final otherUserData = viewModel.getOtherUserData(otherUserID);
    final productImage = viewModel.getProductImage(chatRoom.productID);

    return ListTile(
      leading: _buildLeadingIcons(otherUserData, productImage),
      title: Row(
        children: [
          FutureBuilder(
            future: otherUserData,
            builder: (context, snapshot) {
              return Text(snapshot.data?.name ?? 'null', maxLines: 1);
            },
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
      onTap: () => context.push('/chat_room', extra: {
        'chatRoomId': chatRoom.id,
        'otherUserId':
            userId == chatRoom.buyer ? chatRoom.seller : chatRoom.buyer,
        'productID': chatRoom.productID!,
      }),
    );
  }

  Widget _buildLeadingIcons(
      Future<UserEntity?> userData, Future<String?> productImage) {
    const double iconSize = 40;

    return SizedBox(
      width: iconSize * 1.5,
      height: iconSize * 1.5,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: FutureBuilder(
              future: userData,
              builder: (context, snapshot) =>
                  ProfileImageAvatar(imageUrl: snapshot.data?.image),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: FutureBuilder(
                  future: productImage,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Icon(Icons.photo);
                    }
                    return Image.network(snapshot.data!);
                  }),
            ),
          ),
        ],
      ),
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
      ChatMessageType.location => const Row(
          children: [
            Icon(Icons.location_pin),
            SizedBox(width: 8),
            Text(
              '장소',
              style: TextStyle(color: AppColors.textSecondary),
            )
          ],
        ),
      ChatMessageType.deleted => const Row(
          children: [
            Icon(Icons.delete),
            SizedBox(width: 8),
            Text(
              '삭제된 메시지',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
    };
  }
}
