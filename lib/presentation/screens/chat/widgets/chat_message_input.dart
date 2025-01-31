import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/providers.dart';

class ChatMessageInput extends ConsumerStatefulWidget {
  final String chatRoomId;

  const ChatMessageInput(this.chatRoomId, {super.key});

  @override
  ConsumerState createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends ConsumerState<ChatMessageInput> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorScheme.of(context).surfaceContainerHigh,
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: '메시지 보내기',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  filled: true,
                  fillColor: ColorScheme.of(context).surfaceContainerHigh,
                ),
                onSubmitted: (_) async {
                  await _sendMessage();
                  _messageController.clear();
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await _sendMessage();
              _messageController.clear();
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final senderId = 'a';
    final sendChatMessageUseCase = ref.read(sendChatMessageUseCaseProvider);

    await sendChatMessageUseCase(
        widget.chatRoomId, _messageController.text, senderId);
  }
}
