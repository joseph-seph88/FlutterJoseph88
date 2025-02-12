import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/chat_provider.dart';
import 'package:o2/presentation/widgets/search_place_view.dart';
import 'package:o2/presentation/widgets/select_location_view.dart';

class SendLocationScreen extends ConsumerStatefulWidget {
  final String? chatRoomId;
  final String otherUserId;
  final String productID;

  const SendLocationScreen(
      {super.key,
      required this.chatRoomId,
      required this.otherUserId,
      required this.productID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SendLocationScreenState();
  }
}

class _SendLocationScreenState extends ConsumerState<SendLocationScreen> {
  final _searchController = TextEditingController();
  final GlobalKey<SelectLocationViewState> _mapKey = GlobalKey();
  NaverMapController? get mapController => _mapKey.currentState?.mapController;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('지도')),
      body: Column(
        children: [
          SearchPlaceTextField(textController: _searchController),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SelectLocationView(
                  key: _mapKey,
                  onLocationSelected: _sendLocation,
                ),
                if (isSearching) ...[
                  SearchPlaceResultView(
                    textController: _searchController,
                    mapController: mapController,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendLocation(NLatLng target) async {
    final senderId = ref.read(authProvider)?.id;
    if (senderId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('메시지를 전송할 수 없습니다')));
      return;
    }

    final content = '${target.latitude} ${target.longitude}';
    if (widget.chatRoomId == null) {
      final chatRoomId = await ref.read(createChatRoomProvider)(
          widget.otherUserId, senderId, widget.productID);
      await _sendContent(chatRoomId, senderId, content);
      if (mounted) {
        context.pop();
        context.pushReplacement('/chat_room', extra: {
          'chatRoomId': chatRoomId,
          'otherUserId': widget.otherUserId,
          'productID': widget.productID,
        });
      }
    } else {
      await _sendContent(widget.chatRoomId!, senderId, content);
      if (mounted) context.pop();
    }
  }

  Future<void> _sendContent(
      String chatRoomId, String senderId, String content) async {
    return ref.read(sendContentProvider)(
        chatRoomId, ChatMessageType.location, content, senderId);
  }
}
