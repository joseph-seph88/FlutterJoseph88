import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/date_util.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/presentation/providers/chat_provider.dart';

class ChatMessageList extends ConsumerStatefulWidget {
  final String? chatRoomId;
  final String userId;

  const ChatMessageList(
      {super.key, required this.chatRoomId, required this.userId});

  @override
  ConsumerState createState() => _ChatMessageListState();
}

class _ChatMessageListState extends ConsumerState<ChatMessageList> {
  StreamSubscription? _chatMessageSubscription;

  @override
  void initState() {
    super.initState();
    if (widget.chatRoomId != null) {
      _chatMessageSubscription = ref
          .read(chatMessageProvider.notifier)
          .fetchChatMessages(widget.chatRoomId!);
    }
  }

  @override
  void dispose() {
    _chatMessageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatMessageProvider);

    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        padding: EdgeInsets.all(12),
        itemCount: chatMessages.length,
        itemBuilder: (context, index) {
          final message = chatMessages[index];
          final prevMessage = index > 0 ? chatMessages[index - 1] : null;
          final nextMessage = chatMessages.elementAtOrNull(index + 1);

          final showDateDivider = message.sentTime.toDateOnlyString() !=
              nextMessage?.sentTime.toDateOnlyString();
          final showTimestamp = prevMessage == null ||
              !message.sentTime.isTimeSame(prevMessage.sentTime);
          final isMine = message.senderId == widget.userId;

          return Column(
            children: [
              if (showDateDivider)
                _buildDateDivider(context, message.sentTime.toDateOnlyString()),
              _buildMessageItem(context, message, showTimestamp, isMine),
            ],
          );
        },
      ),
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
      bool showTimestamp, bool isMine) {
    return Padding(
      padding: EdgeInsets.only(bottom: showTimestamp ? 8 : 4),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMine) ...[
            _buildSenderAvatar(),
            SizedBox(width: 8),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMine && showTimestamp) ...[
                _buildTimestamp(context, message.sentTime),
                SizedBox(width: 4),
              ],
              _buildMessageBubble(context, message, isMine),
              if (!isMine && showTimestamp) ...[
                SizedBox(width: 4),
                _buildTimestamp(context, message.sentTime),
              ],
            ],
          ),
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
    final messageMaxWidth = MediaQuery.of(context).size.width * 0.6;
    final messageMaxHeight = MediaQuery.of(context).size.height * 0.4;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(12),
      constraints: BoxConstraints(
        maxWidth: messageMaxWidth,
        maxHeight: messageMaxHeight,
      ),
      decoration: BoxDecoration(
        color:
            isMine ? colorScheme.primary : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: _buildMessageContent(message, isMine, isDarkMode),
    );
  }

  Widget _buildTimestamp(BuildContext context, DateTime sentTime) {
    return Text(
      sentTime.toTimeOnlyString(),
      style: TextStyle(
        fontSize: 12,
        color: ColorScheme.of(context).onSurfaceVariant,
      ),
    );
  }

  Widget _buildMessageContent(
      ChatMessage message, bool isMine, bool isDarkMode) {
    return switch (message.type) {
      ChatMessageType.text => Text(
          message.content,
          style: TextStyle(
            color: isMine || isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ChatMessageType.image => Image.network(
          message.content,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (frame != null) return child;

            return Container(
              color: Colors.grey,
              width: 200,
              height: 200,
              child: const Center(child: Icon(Icons.photo)),
            );
          },
        ),
      ChatMessageType.video => throw UnimplementedError(),
      ChatMessageType.deleted => Text(
          '삭제된 메세지입니다.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
    };
  }
}
