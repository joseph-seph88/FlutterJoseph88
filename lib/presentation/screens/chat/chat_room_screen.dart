import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/image_picker_provider.dart';
import 'package:o2/presentation/providers/providers.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_input.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_list.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String? chatRoomId;
  final String otherUserId;

  const ChatRoomScreen({
    super.key,
    required this.chatRoomId,
    required this.otherUserId,
  });

  @override
  ConsumerState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  bool _isAddButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    final userId = 'a';
    final selectedImage = ref.watch(selectedImageProvider);

    if (widget.chatRoomId != null) {
      final markChatAsReadUseCase = ref.read(markChatAsReadUseCaseProvider);
      markChatAsReadUseCase(widget.chatRoomId!, userId);
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserId)),
      body: Column(
        children: [
          Expanded(
            child:
                ChatMessageList(chatRoomId: widget.chatRoomId, userId: userId),
          ),
          if (selectedImage != null) ...[
            Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Image.file(File(selectedImage.path)),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.close)),
              ],
            )
          ],
          ChatMessageInput(
            chatRoomId: widget.chatRoomId,
            otherUserId: widget.otherUserId,
            isAddButtonClicked: _isAddButtonClicked,
            onAddButtonClicked: _onAddButtonClicked,
          ),
          _isAddButtonClicked
              ? _buildAddItemSelectionField()
              : SizedBox(height: 8),
        ],
      ),
    );
  }

  void _onAddButtonClicked() {
    setState(() {
      _isAddButtonClicked = !_isAddButtonClicked;
    });
  }

  Widget _buildAddItemSelectionField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButtonWithText(
            onPressed: () {
              ref.read(selectedImageProvider.notifier).pickImage();
            },
            icon: Icons.photo,
            text: '사진',
          ),
          _buildIconButtonWithText(
            onPressed: () {},
            icon: Icons.location_pin,
            text: '장소',
          ),
        ],
      ),
    );
  }

  Widget _buildIconButtonWithText(
      {VoidCallback? onPressed, required IconData icon, required String text}) {
    return Column(
      children: [
        IconButton.outlined(onPressed: onPressed, icon: Icon(icon)),
        Text(text, style: TextStyle(color: AppColors.text)),
      ],
    );
  }
}
