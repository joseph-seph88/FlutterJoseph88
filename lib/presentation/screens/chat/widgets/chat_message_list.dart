import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/utils/date_util.dart';
import 'package:o2/presentation/screens/chat/chat_message_list_view_model.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_item.dart';

class ChatMessageList extends ConsumerWidget {
  final String? chatRoomId;
  final String userId;
  final String otherUserId;
  final ChatMessageListViewModel viewModel;

  const ChatMessageList(
      {super.key,
      required this.chatRoomId,
      required this.userId,
      required this.otherUserId,
      required this.viewModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatMessageListViewModelProvider(chatRoomId));

    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        padding: const EdgeInsets.all(12),
        findChildIndexCallback: (key) {
          return messages.indexWhere((element) => key == ValueKey(element.id));
        },
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final prevMessage = index > 0 ? messages[index - 1] : null;
          final nextMessage = messages.elementAtOrNull(index + 1);

          final showDateDivider = message.sentTime.toDateOnlyString() !=
              nextMessage?.sentTime.toDateOnlyString();
          final showTimestamp = prevMessage == null ||
              !message.sentTime.isTimeSame(prevMessage.sentTime);
          final isMine = message.senderId == userId;

          return ChatMessageItem(
            key: ValueKey(message.id),
            message: message,
            chatRoomId: chatRoomId,
            otherUserId: otherUserId,
            showDateDivider: showDateDivider,
            showTimestamp: showTimestamp,
            isMine: isMine,
            viewModel: viewModel,
          );
        },
      ),
    );
  }
}
