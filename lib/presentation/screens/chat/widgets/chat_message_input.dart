import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/presentation/providers/image_picker_provider.dart';
import 'package:o2/presentation/screens/chat/chat_message_list_view_model.dart';

class ChatMessageInput extends ConsumerStatefulWidget {
  final String? chatRoomId;
  final String userId;
  final String otherUserId;
  final String productID;
  final bool isAddButtonClicked;
  final File? selectedImage;
  final Function onAddButtonClicked;

  const ChatMessageInput(
      {super.key,
      required this.chatRoomId,
      required this.userId,
      required this.otherUserId,
      required this.productID,
      required this.isAddButtonClicked,
      required this.selectedImage,
      required this.onAddButtonClicked});

  @override
  ConsumerState<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends ConsumerState<ChatMessageInput>
    with SingleTickerProviderStateMixin {
  final _messageController = TextEditingController();
  final _textFieldFocusNode = FocusNode();
  late final AnimationController _animationController;
  bool _isSending = false;

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
          _buildSendButton(_isSending),
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
          focusNode: _textFieldFocusNode,
          textInputAction: TextInputAction.send,
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
          onSubmitted: (_) {
            _textFieldFocusNode.requestFocus();
            _handleMessageSubmitted();
          },
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
        ),
      ),
    );
  }

  Widget _buildSendButton(bool isSending) {
    return IconButton(
      constraints: const BoxConstraints(maxWidth: 40, maxHeight: 40),
      onPressed: isSending ? null : _handleSendButtonPressed,
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

  void _handleMessageSubmitted() {
    _sendMessage(_messageController.text);
    _messageController.clear();
  }

  Future<void> _handleSendButtonPressed() async {
    setState(() {
      _isSending = true;
    });

    _handleMessageSubmitted();
    ref.read(selectedImageProvider.notifier).clear();

    setState(() {
      _isSending = false;
    });
  }

  Future<void> _sendMessage(String text) async {
    final viewModel =
        ref.read(chatMessageListViewModelProvider(widget.chatRoomId).notifier);

    final chatRoomId = await viewModel.sendMessage(
      chatRoomId: widget.chatRoomId,
      senderId: widget.userId,
      otherUserId: widget.otherUserId,
      productId: widget.productID,
      message: text,
      image: widget.selectedImage,
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
