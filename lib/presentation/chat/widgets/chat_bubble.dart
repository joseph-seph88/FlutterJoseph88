import 'dart:io';
import 'package:flutter/material.dart';
import 'package:personal_select_chat/core/theme/app_style.dart';
import 'package:personal_select_chat/core/utils/app_constant.dart';
import 'package:personal_select_chat/data/models/chat_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final dateFormat = message.timestamp;
    final formattedTime = "${dateFormat.hour}:${dateFormat.minute}";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          message.isMine
              ? SizedBox.shrink()
              : CircleAvatar(
                  backgroundImage: AssetImage(AppImage.batman), radius: 16),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(18.0)),
                child: message.text != null && message.text!.isNotEmpty
                    ? Text(message.text!, style: AppStyle.generalBody())
                    : message.imagePaths.isNotEmpty
                        ? Column(
                            children: message.imagePaths
                                .where((path) => path != null)
                                .map((path) => Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Image.file(File(path!)),
                                    ))
                                .toList(),
                          )
                        : SizedBox(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child:
                    Text(formattedTime, style: AppStyle.generalSmallSubBody()),
              ),
            ],
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
