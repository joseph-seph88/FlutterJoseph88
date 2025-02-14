import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/utils/date_util.dart';
import 'package:o2/presentation/screens/chat/chat_message_list_view_model.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_item.dart';

class ChatMessageList extends ConsumerStatefulWidget {
  final String? chatRoomId;
  final String userId;
  final String otherUserId;
  final ChatMessageListViewModel viewModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ChatMessageListState();

  const ChatMessageList({super.key,
    required this.chatRoomId,
    required this.userId,
    required this.otherUserId,
    required this.viewModel});
}

class ChatMessageListState extends ConsumerState<ChatMessageList> {
  final _scrollController = ScrollController();
  late final String? chatRoomId;
  late final String userId;
  late final String otherUserId;
  late final ChatMessageListViewModel viewModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    chatRoomId = widget.chatRoomId;
    userId = widget.userId;
    otherUserId = widget.otherUserId;
    viewModel = widget.viewModel;

    _scrollController.addListener(() async {
      if (!_isLoading && _scrollController.position.extentAfter < 100) {
        _isLoading = true;
        await viewModel.fetchMoreMessages();
        _isLoading = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessageListViewModelProvider(chatRoomId));

    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        padding: const EdgeInsets.all(12),
        controller: _scrollController,
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
