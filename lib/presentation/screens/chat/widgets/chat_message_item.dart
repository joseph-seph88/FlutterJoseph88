import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/date_util.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/presentation/screens/chat/chat_message_list_view_model.dart';
import 'package:o2/presentation/widgets/profile_image.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;
  final String? chatRoomId;
  final String otherUserId;
  final bool showDateDivider;
  final bool showTimestamp;
  final bool isMine;
  final ChatMessageListViewModel viewModel;

  const ChatMessageItem(
      {super.key,
      required this.message,
      required this.chatRoomId,
      required this.otherUserId,
      required this.showDateDivider,
      required this.showTimestamp,
      required this.isMine,
      required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDateDivider)
          _buildDateDivider(context, message.sentTime.toDateOnlyString()),
        _buildMessageItem(context, message, showTimestamp, isMine),
      ],
    );
  }

  Widget _buildDateDivider(BuildContext context, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        date,
        style: TextStyle(
          color: ColorScheme.of(context).onSurfaceVariant,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, ChatMessage message,
      bool showTimestamp, bool isMine) {
    return Padding(
      padding: EdgeInsets.only(bottom: showTimestamp ? 8 : 4),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMine) ...[
            _buildSenderAvatar(),
            const SizedBox(width: 8),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMine && showTimestamp) ...[
                _buildTimestamp(context, message.sentTime),
                const SizedBox(width: 4),
              ],
              _buildMessageBubble(context, message, isMine),
              if (!isMine && showTimestamp) ...[
                const SizedBox(width: 4),
                _buildTimestamp(context, message.sentTime),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSenderAvatar() {
    final otherUserData = viewModel.getOtherUserData(otherUserId);

    return FutureBuilder(
      future: otherUserData,
      builder: (context, snapshot) => ProfileImageAvatar(
        imageUrl: snapshot.data?.image,
      ),
    );
  }

  Widget _buildMessageBubble(
      BuildContext context, ChatMessage message, bool isMine) {
    final colorScheme = ColorScheme.of(context);
    final messageMaxWidth = MediaQuery.of(context).size.width * 0.6;
    final messageMaxHeight = MediaQuery.of(context).size.height * 0.4;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onLongPress: () => _showMessagePopupMenu(context, message.id, isMine),
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: messageMaxWidth,
          maxHeight: messageMaxHeight,
        ),
        decoration: BoxDecoration(
          color: isMine
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: _buildMessageContent(context, message, isMine, isDarkMode),
      ),
    );
  }

  void _showMessagePopupMenu(
      BuildContext context, String messageId, bool isMine) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'chat_message_menu',
      pageBuilder: (context, animation, secondaryAnimation) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            if (isMine) ...[
              SimpleDialogOption(
                onPressed: () {
                  viewModel.deleteMessage(messageId);
                  context.pop();
                },
                child: const Text(
                  '삭제',
                  style: TextStyle(color: AppColors.text),
                ),
              )
            ],
          ],
        );
      },
    );
  }

  Widget _buildTimestamp(BuildContext context, DateTime sentTime) {
    return Text(
      sentTime.toTimeOnlyString(),
      style: TextStyle(
        fontSize: 12,
        color: ColorScheme.of(context).onSurfaceVariant,
      ),
    );
  }

  Widget _buildMessageContent(
      BuildContext context, ChatMessage message, bool isMine, bool isDarkMode) {
    switch (message.type) {
      case ChatMessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            color: isMine || isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        );
      case ChatMessageType.image:
        return GestureDetector(
          onTap: () {
            context.push('/image_view', extra: {
              'url': message.content,
            });
          },
          child: Image.network(
            message.content,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (frame != null) return child;

              return Container(
                color: Colors.grey,
                width: 200,
                height: 200,
                child: const Center(child: Icon(Icons.photo)),
              );
            },
          ),
        );
      case ChatMessageType.video:
        throw UnimplementedError();
      case ChatMessageType.location:
        final split = message.content.split(' ').map(double.tryParse);
        final target = split.contains(null)
            ? NaverMapViewOptions.seoulCityHall.target
            : NLatLng(split.first!, split.last!);

        return GestureDetector(
          onTap: () {
            context.push('/map_view', extra: target);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: AbsorbPointer(
                    child: NaverMap(
                      options: NaverMapViewOptions(
                        initialCameraPosition:
                            NCameraPosition(target: target, zoom: 14),
                        rotationGesturesEnable: false,
                        scrollGesturesEnable: false,
                        tiltGesturesEnable: false,
                        zoomGesturesEnable: false,
                        stopGesturesEnable: false,
                      ),
                      onMapReady: (controller) =>
                          _addMarker(controller, target),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder(
                future: viewModel.getAddress(message.content),
                builder: (context, snapshot) => Text(
                  snapshot.data ?? '',
                  style: TextStyle(
                    color: isMine || isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      case ChatMessageType.deleted:
        return const Text(
          '삭제된 메세지입니다.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        );
    }
  }

  void _addMarker(NaverMapController controller, NLatLng target) {
    final marker = NMarker(id: 'location', position: target);

    controller.addOverlay(marker);
  }
}
