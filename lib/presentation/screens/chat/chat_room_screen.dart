import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/format_utils.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/chat_provider.dart';
import 'package:o2/presentation/providers/image_picker_provider.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/providers/providers.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_input.dart';
import 'package:o2/presentation/screens/chat/widgets/chat_message_list.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String? chatRoomId;
  final String otherUserId;
  final String productID;

  const ChatRoomScreen({
    super.key,
    required this.chatRoomId,
    required this.otherUserId,
    required this.productID,
  });

  @override
  ConsumerState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  bool _isAddButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authProvider)?.id;
    if (userId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error),
            Text('채팅 내역을 불러오던 중 문제가 발생했습니다!'),
          ],
        ),
      );
    }
    final selectedImage = ref.watch(selectedImageProvider);
    final otherUserData = ref.watch(otherUserProvider)(widget.otherUserId);

    if (widget.chatRoomId != null) {
      ref.read(readChatProvider)(widget.chatRoomId!, userId);
    }

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: otherUserData,
          builder: (context, snapshot) {
            return Text(snapshot.data?.name ?? '');
          },
        ),
      ),
      body: Column(
        children: [
          _buildProductInfo(),
          const Divider(),
          Expanded(
            child:
                ChatMessageList(chatRoomId: widget.chatRoomId, userId: userId),
          ),
          if (selectedImage != null) ...[
            _buildSelectedImage(selectedImage.path)
          ],
          ChatMessageInput(
            chatRoomId: widget.chatRoomId,
            otherUserId: widget.otherUserId,
            productID: widget.productID,
            isAddButtonClicked: _isAddButtonClicked,
            onAddButtonClicked: _onAddButtonClicked,
          ),
          _isAddButtonClicked
              ? _buildAddItemSelectionField()
              : const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _onAddButtonClicked() {
    setState(() {
      _isAddButtonClicked = !_isAddButtonClicked;
    });
  }

  Widget _buildProductInfo() {
    const double imageSize = 60;
    final productAsync = ref.watch(productDetailProvider(widget.productID));

    return Padding(
      padding: AppStyles.defaultPadding,
      child: productAsync.when(
        data: (data) {
          if (data == null) return const SizedBox.shrink();

          return Row(
            children: [
              Image.network(
                data.images.first,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: AppStyles.defaultSpacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${data.status} ',
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data.title,
                        style: const TextStyle(color: AppColors.text),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        data.price.toPrice(),
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data.isOfferEnabled ? '(가격제안가능)' : '(가격제안불가)',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
        error: (error, stackTrace) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildAddItemSelectionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
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
            onPressed: () {
              context.push('/send_location', extra: {
                if (widget.chatRoomId != null) ...{
                  'chatRoomId': widget.chatRoomId!
                },
                'otherUserId': widget.otherUserId,
                'productID': widget.productID,
              });
            },
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
        Text(text, style: const TextStyle(color: AppColors.text)),
      ],
    );
  }

  Widget _buildSelectedImage(String path) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          color: AppColors.surface,
          child: Center(
            child: Image.file(File(path)),
          ),
        ),
        IconButton(
            onPressed: () {
              ref.read(selectedImageProvider.notifier).clear();
            },
            icon: const Icon(Icons.close)),
      ],
    );
  }
}
