import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/chat_provider.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_room_list.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState createState() => _ChatListScreenState();
}

enum FilterType { all, selling, buying }

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  FilterType _filterType = FilterType.all;

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authProvider)?.id;
    if (userId == null) {
      return const Center(
        child: Column(
          children: [
            Icon(Icons.error),
            Text('채팅 내역을 불러오던 중 문제가 발생했습니다!'),
          ],
        ),
      );
    }

    final chatRooms = ref
        .watch(chatRoomProvider)
        .where(
            (element) => _shouldIncludeChatRoom(_filterType, userId, element))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('채팅')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildFilterChips(),
          ),
          Expanded(
              child: ChatRoomList(chatRoomList: chatRooms, userId: userId)),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 4,
      children: FilterType.values.map((filter) {
        return ChoiceChip(
          label: Text(_filterLabel(filter)),
          selected: _filterType == filter,
          showCheckmark: false,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _filterType = filter;
              });
            }
          },
        );
      }).toList(),
    );
  }

  String _filterLabel(FilterType type) {
    switch (type) {
      case FilterType.all:
        return '전체';
      case FilterType.selling:
        return '판매';
      case FilterType.buying:
        return '구매';
    }
  }

  bool _shouldIncludeChatRoom(
      FilterType type, String userId, ChatRoom chatRoom) {
    switch (type) {
      case FilterType.all:
        return true;
      case FilterType.selling:
        return chatRoom.seller == userId;
      case FilterType.buying:
        return chatRoom.buyer == userId;
    }
  }
}
