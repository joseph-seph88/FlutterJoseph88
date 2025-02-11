import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/presentation/providers/image_picker_provider.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_input_view_model.dart';

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
    final isSending = ref.watch(chatMessageInputViewModelProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _buildAddButton(),
          _buildMessageTextField(),
          _buildSendButton(isSending),
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

  Widget _buildSendButton(bool isSending) {
    return IconButton(
      constraints: const BoxConstraints(maxWidth: 40, maxHeight: 40),
      onPressed: isSending ? null : _handleMessageSubmitted,
      icon: isSending
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
    ref.read(selectedImageProvider.notifier).clear();
  }

  Future<void> _sendMessage() async {
    final viewModel = ref.read(chatMessageInputViewModelProvider.notifier);

    final chatRoomId = await viewModel.sendMessage(
      chatRoomId: widget.chatRoomId,
      otherUserId: widget.otherUserId,
      productId: widget.productID,
      message: _messageController.text,
    );

    if (widget.chatRoomId == null) {
      if (mounted) {
        context.pushReplacement('/chat_room', extra: {
          'chatRoomId': chatRoomId!,
          'otherUserId': widget.otherUserId,
          'productID': widget.productID,
        });
      }
    }
  }
}
