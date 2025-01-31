import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/utils/date_util.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/presentation/providers/chat_provider.dart';

class ChatMessageList extends ConsumerWidget {
  final String chatRoomId;
  final String userId;

  const ChatMessageList(
      {super.key, required this.chatRoomId, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(chatMessageProvider.notifier).fetchChatMessages(chatRoomId);
    final chatMessages = ref.watch(chatMessageProvider);
    String? currentDate;
    String currentSender = chatMessages.firstOrNull?.senderId ?? '';

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: chatMessages.length,
      itemBuilder: (context, index) {
        final message = chatMessages[index];
        final messageDate = message.sentTime.toDateOnlyString();
        final messageSender = message.senderId;
        final showDateDivider = currentDate != messageDate;
        final showTimestamp = index == chatMessages.length - 1 ||
            messageSender != chatMessages[index + 1].senderId ||
            !message.sentTime.isTimeSame(chatMessages[index + 1].sentTime);
        final isSenderChanged = currentSender != messageSender;
        final isMine = messageSender == userId;

        if (showDateDivider) {
          currentDate = messageDate;
        }
        if (isSenderChanged) {
          currentSender = messageSender;
        }

        return Column(
          children: [
            if (showDateDivider) _buildDateDivider(context, messageDate),
            _buildMessageItem(
                context, message, showTimestamp, isSenderChanged, isMine),
          ],
        );
      },
    );
  }

  Widget _buildDateDivider(BuildContext context, String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        date,
        style: TextStyle(
          color: ColorScheme.of(context).onSurfaceVariant,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, ChatMessage message,
      bool showTimestamp, bool isSenderChanged, bool isMine) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSenderChanged ? 8 : 4),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            _buildSenderAvatar(),
            SizedBox(width: 8),
          ],
          if (isMine && showTimestamp) ...[
            Text(
              message.sentTime.toTimeOnlyString(),
              style: TextStyle(
                fontSize: 12,
                color: ColorScheme.of(context).onSurfaceVariant,
              ),
            ),
            SizedBox(width: 4),
          ],
          _buildMessageBubble(context, message, isMine),
          if (!isMine && showTimestamp) ...[
            SizedBox(width: 4),
            Text(
              message.sentTime.toTimeOnlyString(),
              style: TextStyle(
                fontSize: 12,
                color: ColorScheme.of(context).onSurfaceVariant,
              ),
            )
          ],
        ],
      ),
    );
  }

  Widget _buildSenderAvatar() {
    return CircleAvatar();
  }

  Widget _buildMessageBubble(
      BuildContext context, ChatMessage message, bool isMine) {
    final colorScheme = ColorScheme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isMine ? colorScheme.primary : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          color: isMine || isDarkMode ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
