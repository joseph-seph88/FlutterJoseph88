import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/presentation/providers/image_picker_provider.dart';
import 'package:o2/presentation/providers/providers.dart';

class ChatMessageInput extends ConsumerStatefulWidget {
  final String? chatRoomId;
  final String otherUserId;
  final bool isAddButtonClicked;
  final Function onAddButtonClicked;

  const ChatMessageInput(
      {super.key,
      required this.chatRoomId,
      required this.otherUserId,
      required this.isAddButtonClicked,
      required this.onAddButtonClicked});

  @override
  ConsumerState createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends ConsumerState<ChatMessageInput>
    with SingleTickerProviderStateMixin {
  final _messageController = TextEditingController();
  late final AnimationController _animationController;
  bool _isSendingMessage = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

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
          RotationTransition(
            turns: Tween(begin: 0.0, end: 0.125).animate(_animationController),
            child: IconButton(
                onPressed: () {
                  widget.onAddButtonClicked();
                  widget.isAddButtonClicked
                      ? _animationController.reverse()
                      : _animationController.forward();
                },
                icon: Icon(Icons.add)),
          ),
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
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ),
          IconButton(
            onPressed: _isSendingMessage ? null : () async {
              setState(() {
                _isSendingMessage = true;
              });
              await _sendMessage();

              _messageController.clear();
              ref.read(selectedImageProvider.notifier).clear();
              setState(() {
                _isSendingMessage = false;
              });
            },
            icon: _isSendingMessage ? CircularProgressIndicator() : Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final senderId = 'a';
    final sendChatMessageUseCase = ref.read(sendChatMessageUseCaseProvider);
    final sendChatImageUseCase = ref.read(sendChatImageUseCaseProvider);

    if (widget.chatRoomId == null) {
      final createChatRoomUseCase = ref.read(createChatRoomUseCaseProvider);
      final chatRoomId = await createChatRoomUseCase(
          _messageController.text, widget.otherUserId, senderId);
      if (mounted) {
        context.go('/chats/chat_room', extra: {
          'chatRoomId': chatRoomId,
          'otherUserId': widget.otherUserId,
        });
      }
    } else {
      await Future.wait([
        Future(() async {
          if (_messageController.text.isNotEmpty) {
            await sendChatMessageUseCase(widget.chatRoomId!, ChatMessageType.text,
                _messageController.text, senderId);
          }
        }),
        Future(() async {
          if (ref.read(selectedImageProvider) != null) {
            await sendChatImageUseCase(widget.chatRoomId!, ChatMessageType.image,
                ref.read(selectedImageProvider)!.path, senderId);
          }
        }),
      ]);
    }
  }
}
