import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/image_picker_provider.dart';
import 'package:o2/presentation/providers/providers.dart';

class ChatMessageInput extends ConsumerStatefulWidget {
  final String? chatRoomId;
  final String otherUserId;
  final String productID;
  final bool isAddButtonClicked;
  final Function onAddButtonClicked;

  const ChatMessageInput(
      {super.key,
      required this.chatRoomId,
      required this.otherUserId,
      required this.productID,
      required this.isAddButtonClicked,
      required this.onAddButtonClicked});

  @override
  ConsumerState<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends ConsumerState<ChatMessageInput>
    with SingleTickerProviderStateMixin {
  final _messageController = TextEditingController();
  late final AnimationController _animationController;
  bool _isSendingMessage = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _buildAddButton(),
          _buildMessageTextField(),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.125).animate(_animationController),
      child: IconButton(
        onPressed: _handleAddButtonPressed,
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMessageTextField() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorScheme.of(context).surfaceContainerHigh,
        ),
        child: TextField(
          controller: _messageController,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: '메시지 보내기',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            filled: true,
            fillColor: ColorScheme.of(context).surfaceContainerHigh,
          ),
          onSubmitted: (_) => _handleMessageSubmitted(),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return IconButton(
      constraints: const BoxConstraints(maxWidth: 40, maxHeight: 40),
      onPressed: _isSendingMessage ? null : _handleSendButtonPressed,
      icon: _isSendingMessage
          ? const CircularProgressIndicator()
          : const Icon(Icons.send),
    );
  }

  void _handleAddButtonPressed() {
    widget.onAddButtonClicked();
    if (widget.isAddButtonClicked) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  Future<void> _handleMessageSubmitted() async {
    await _sendMessage();
    _messageController.clear();
  }

  void _handleSendButtonPressed() async {
    setState(() => _isSendingMessage = true);
    await _handleMessageSubmitted();
    ref.read(selectedImageProvider.notifier).clear();
    setState(() => _isSendingMessage = false);
  }

  Future<void> _sendMessage() async {
    final senderId = ref.read(authProvider)?.id;
    if (senderId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('메시지를 전송할 수 없습니다')));
      return;
    }

    if (widget.chatRoomId == null) {
      final chatRoomId = await _createChatRoom(senderId);
      await _sendContent(chatRoomId, senderId);
      if (mounted) {
        context.pushReplacement('/chat_room', extra: {
          'chatRoomId': chatRoomId,
          'otherUserId': widget.otherUserId,
          'productID': widget.productID,
        });
      }
    } else {
      await _sendContent(widget.chatRoomId!, senderId);
    }
  }

  Future<String> _createChatRoom(String senderId) {
    final createChatRoomUseCase = ref.read(createChatRoomUseCaseProvider);
    return createChatRoomUseCase(widget.otherUserId, senderId, widget.productID);
  }

  Future<void> _sendContent(String chatRoomId, String senderId) async {
    final sendChatMessageUseCase = ref.read(sendChatMessageUseCaseProvider);
    final sendChatImageUseCase = ref.read(sendChatImageUseCaseProvider);

    await Future.wait([
      Future(() async {
        if (_messageController.text.isNotEmpty) {
          await sendChatMessageUseCase(chatRoomId, ChatMessageType.text,
              _messageController.text, senderId);
        }
      }),
      Future(() async {
        if (ref.read(selectedImageProvider) != null) {
          await sendChatImageUseCase(
            chatRoomId,
            ChatMessageType.image,
            ref.read(selectedImageProvider)!.path,
            senderId,
          );
        }
      }),
    ]);
  }
}
