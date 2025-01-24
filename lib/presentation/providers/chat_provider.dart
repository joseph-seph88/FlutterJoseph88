import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/entities/chat_room.dart';

final chatRoomProvider = StateNotifierProvider<ChatRoomNotifier, List<ChatRoom>>(
  (ref) => ChatRoomNotifier(),
);

class ChatRoomNotifier extends StateNotifier<List<ChatRoom>> {

  ChatRoomNotifier() : super([
    ChatRoom(id: '0', buyer: 'buyer', seller: 'seller', unreadMessageCount: 0),
    ChatRoom(id: '1',
      buyer: 'buyer',
      seller: 'seller',
      unreadMessageCount: 1,
      lastMessage: 'hi',
      lastMessageSender: 'buyer',
      lastMessageTime: DateTime(2025, 1, 1),
    ),
    ChatRoom(id: '2',
      buyer: 'buyer',
      seller: 'seller',
      unreadMessageCount: 2,
      lastMessage: 'hello',
      lastMessageSender: 'seller',
      lastMessageTime: DateTime(2024, 11, 1),
    ),
    ChatRoom(id: '3', buyer: 'buyer', seller: "seller", unreadMessageCount: 0),
  ]);
}