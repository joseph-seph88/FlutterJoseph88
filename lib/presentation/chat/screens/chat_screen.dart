import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_select_chat/bloc/chat/chat_bloc.dart';
import 'package:personal_select_chat/bloc/chat/chat_event.dart';
import 'package:personal_select_chat/bloc/chat/chat_state.dart';
import 'package:personal_select_chat/core/theme/app_style.dart';
import 'package:personal_select_chat/core/theme/widget_style.dart';
import 'package:personal_select_chat/data/models/chat_model.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateTime.now();
    final formattedTime =
        "${dateFormat.year}년 ${dateFormat.month}월 ${dateFormat.day}일";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        toolbarHeight: 40,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Text(formattedTime,
                    style: AppStyle.generalMediumSubBody())),
            Expanded(
              child:
                  BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
                List<Widget> chatItems = [];
                if (state is UpdateChatState) {
                  for (var message in state.messageList) {
                    if (message.text != null || message.imagePaths.isNotEmpty) {
                      chatItems.add(MessageBubble(message: message));
                    }
                  }
                }
                return _buildChatMessage(context, chatItems);
              }),
            ),
            _buildInputSection(context),
          ],
        ),
      ),
    );
  }

  void sendMessage(BuildContext context, ChatModel message) {
    context.read<ChatBloc>().add(SendMessageEvent(message));
    _textEditingController.clear();
  }

  void selectedImage(BuildContext context) async {
    final images = await _imagePicker.pickMultiImage();
    if (images.isNotEmpty && context.mounted) {
      final imagePaths = images.map((file) => file.path).toList();
      context.read<ChatBloc>().add(SendImageEvent(imagePaths));
    }
  }

  Widget _buildChatMessage(BuildContext context, List<Widget> chatItems) {
    return ListView.builder(
      itemCount: chatItems.length,
      itemBuilder: (context, index) {
        return chatItems[index];
      },
      reverse: false,
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Container(
            decoration: WidgetStyle.gradientGreyBtnDecoration(),
            child: IconButton(
                onPressed: () => selectedImage(context),
                icon: Icon(Icons.image,
                    size: 32.0, color: Colors.indigo.shade300)),
          ),
        ),
        Expanded(
            child: Container(
          decoration: WidgetStyle.greyTextFieldDecoration(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: "메시지 입력..",
                hintStyle: AppStyle.generalMediumSubBody(),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              minLines: 1,
              maxLines: 4,
              onTapOutside: (_) => FocusScope.of(context).unfocus()),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            decoration: WidgetStyle.indigoBtnDecoration(),
            child: IconButton(
                onPressed: () {
                  final inputMsg = _textEditingController.text;
                  if (inputMsg.isNotEmpty) {
                    final message = ChatModel(text: inputMsg, isMine: true);
                    sendMessage(context, message);
                  }
                },
                icon: Icon(Icons.send, color: Colors.white, size: 24)),
          ),
        )
      ],
    );
  }
}
