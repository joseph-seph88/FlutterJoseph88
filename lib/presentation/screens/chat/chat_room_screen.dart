import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/format_utils.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/image_picker_provider.dart';
import 'package:o2/presentation/screens/chat/chat_message_list_view_model.dart';
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
  late final ChatMessageListViewModel _viewModel;
  bool _isAddButtonClicked = false;

  @override
  void initState() {
    super.initState();
    _viewModel =
        ref.read(chatMessageListViewModelProvider(widget.chatRoomId).notifier);
  }

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
    final otherUserData = _viewModel.getOtherUserData(widget.otherUserId);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: otherUserData,
          builder: (context, snapshot) {
            return Text(snapshot.data?.name ?? '알 수 없는 사용자');
          },
        ),
      ),
      body: Column(
        children: [
          _buildProductInfo(),
          const Divider(),
          Expanded(
            child: ChatMessageList(
              chatRoomId: widget.chatRoomId,
              userId: userId,
              otherUserId: widget.otherUserId,
              viewModel: _viewModel,
            ),
          ),
          if (selectedImage != null) ...[
            _buildSelectedImage(selectedImage.path)
          ],
          ChatMessageInput(
            chatRoomId: widget.chatRoomId,
            userId: userId,
            otherUserId: widget.otherUserId,
            productID: widget.productID,
            isAddButtonClicked: _isAddButtonClicked,
            selectedImage: selectedImage,
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
    final product = _viewModel.getProductDetail(widget.productID);

    return FutureBuilder(
      future: product,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final data = snapshot.data!;
        return InkWell(
          onTap: () => context.push('/detail/${data.id}'),
          child: Padding(
            padding: AppStyles.defaultPadding,
            child: Row(
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${data.status.label} ',
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
            ),
          ),
        );
      },
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
