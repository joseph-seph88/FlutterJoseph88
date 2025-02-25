import 'dart:io';
import 'package:chatbots/presentation/widgets/background_snowfall_config.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';
import '../../core/theme/widget_style.dart';
import '../../core/utils/app_constant.dart';
import '../controller/tf_chat_view_controller.dart';

class TfChatView extends GetView<TfChatViewController> {
  const TfChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: WidgetStyle().backBoxDecoration()),
          SnowFallAnimation(
              config: BackgroundSnowfallConfig().snowfallConfig()),
          Positioned(
              top: 50,
              left: 0,
              right: 0,
              bottom: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContainer(),
                  Obx(
                    () => Expanded(child: _buildDashChat()),
                  ),
                ],
              )),
          Obx(() => controller.isTyping.value
              ? const Center(
                  child: LoadingIndicator(
                      indicatorType: Indicator.orbit, colors: [Colors.white70]))
              : Container()),
          Obx(() => controller.isSpeeching.value
              ? const Center(
                  child: LoadingIndicator(
                      indicatorType: Indicator.semiCircleSpin,
                      colors: [Colors.white70]))
              : Container()),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(child: _buildCard(context)),
                Obx(() => _buildBtn()),
                const SizedBox(width: 8),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _sendMessage() async {
    controller.sendChatMessage();
  }

  void _pickImage() async {
    controller.selectImage();
  }

  Widget _buildContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() => ElevatedButton(
            onPressed: () {
              controller.isFeature.value = !controller.isFeature.value;
              controller.featureIndex.value =
                  controller.isFeature.value ? 1 : 0;
            },
            child: Text(controller.isFeature.value
                ? controller.tfSelect[1]
                : controller.tfSelect[0]),
          )),
    );
  }

  Widget _buildDashChat() {
    return DashChat(
      currentUser: controller.myUser.value,
      onSend: (ChatMessage message) {},
      messages: controller.messages.toList(),
      readOnly: true,
      messageOptions: MessageOptions(
        marginDifferentAuthor: const EdgeInsets.symmetric(vertical: 5),
        marginSameAuthor: const EdgeInsets.symmetric(vertical: 5),
        avatarBuilder: (ChatUser user, Function? onPressAvatar,
            Function? onLongPressAvatar) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              // onTap: () => onPressAvatar?.call(),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(AppConstant.pictureRandom),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(context) {
    return Card(
      child: TextField(
        controller: controller.textController,
        onChanged: (value) => controller.updateMessage(value),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '메시지 입력...',
          prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: IconButton(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.attach_file_sharp))),
          suffixIcon: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                controller.image.value != null
                    ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.file(
                          File(controller.image.value!.path),
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const SizedBox.shrink(),
                IconButton(
                    onPressed: () {
                      // _speechToText();
                    },
                    icon: const Icon(Icons.mic)),
              ],
            ),
          ),
        ),
        minLines: 1,
        maxLines: 4,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  Widget _buildBtn() {
    return Container(
      decoration:
          WidgetStyle().sendBoxDecoration(controller.message.isNotEmpty),
      child: IconButton(
          onPressed: () {
            if (controller.textController.text.isNotEmpty) {
              _sendMessage();
            }
          },
          icon: const Icon(Icons.send)),
    );
  }
}
