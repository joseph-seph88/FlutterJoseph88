import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/entities/chat_room.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/providers.dart';

final chatRoomStreamProvider = StreamProvider<List<ChatRoom>>((ref) {
  final userId = ref.read(authProvider)?.id;
  if (userId == null) return Stream.error('not_logged_in');

  final getChatRoomsUseCase = ref.read(getChatRoomsUseCaseProvider);
  return getChatRoomsUseCase(userId);
});

final chatMessageStreamProvider = StreamProvider.autoDispose
    .family<List<ChatMessage>, String>((ref, chatRoomId) {
  final userId = ref.watch(authProvider)?.id;
  if (userId == null) return Stream.error('not_logged_in');

  final getChatMessagesUseCase = ref.read(getChatMessagesUseCaseProvider);
  return getChatMessagesUseCase(chatRoomId);
});
