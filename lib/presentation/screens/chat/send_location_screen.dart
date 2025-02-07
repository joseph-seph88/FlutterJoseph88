import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/domain/entities/chat_message.dart';
import 'package:o2/domain/usecases/map_use_case.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/providers.dart';

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
  NaverMapController? _mapController;
  bool _isSearching = false;
  bool _isInfoWindowPressed = false;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('지도')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: const BoxDecoration(color: AppColors.surface),
            child: _buildSearchTextField(),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                NaverMap(
                  onMapReady: (controller) {
                    _mapController = controller;
                    ref.read(_currentTargetProvider.notifier).state =
                        AsyncData(_mapController!.nowCameraPosition.target);
                  },
                  onCameraChange: (reason, animated) {
                    ref.read(_currentTargetProvider.notifier).state =
                        const AsyncLoading();
                  },
                  onCameraIdle: () {
                    ref.read(_currentTargetProvider.notifier).state =
                        AsyncData(_mapController!.nowCameraPosition.target);
                  },
                ),
                _buildCenterMarker(),
                if (_isSearching) ...[_buildSearchResult(_searchController.text)],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: ColorScheme.of(context).surfaceContainerHigh,
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: '장소명으로 검색',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          filled: true,
          fillColor: ColorScheme.of(context).surfaceContainerHigh,
        ),
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          if (value.isEmpty) {
            setState(() {
              _isSearching = false;
            });
            return;
          }

          _debounce = Timer(const Duration(seconds: 1), () {
            setState(() {
              _isSearching = _searchController.text.isNotEmpty;
            });
          });
        },
        onSubmitted: (_) {},
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  Widget _buildSearchResult(String input) {
    final result = ref.watch(_searchResultProvider(input));

    return Container(
      color: AppColors.surface,
      child: result.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return ListTile(
                title: Text(item.primaryText),
                subtitle: Text(item.secondaryText),
                trailing: const Icon(Icons.outbond_outlined),
                onTap: () async {

                },
              );
            },
          );
        },
        error: (error, stackTrace) {
          return const Center(child: Text('검색 중 오류가 발생했습니다.'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCenterMarker() {
    const double height = 100;

    return Transform.translate(
      offset: const Offset(0, -0.5 * height),
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildInfoWindow(),
            const SizedBox(height: 8),
            Image.asset(
              'assets/icons/marker.png',
              height: 32,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoWindow() {
    final currentAddress = ref.watch(_currentAddressProvider);

    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _isInfoWindowPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _isInfoWindowPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isInfoWindowPressed = false;
        });
      },
      onTap: currentAddress.isLoading ? null : () {
        final target = ref.read(_currentTargetProvider).value;
        if (target == null) return;

        final location = '${target.latitude} ${target.longitude}';
        _sendMessage(location);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: _isInfoWindowPressed ? Colors.grey : AppColors.surface,
          border: Border.all(),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 1),
              blurRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: currentAddress.when(
          data: (data) {
            return _buildInfoWindowText(data?.street ?? 'null');
          },
          error: (error, stackTrace) {
            return const Text('주소를 불러오던 중 오류가 발생했습니다');
          },
          loading: () {
            return Transform.scale(
              scale: 0.5,
              child: const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoWindowText(String address) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '장소 보내기',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              child: Text(
                address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }

  Future<void> _sendMessage(String content) async {
    final senderId = ref.read(authProvider)?.id;
    if (senderId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('메시지를 전송할 수 없습니다')));
      return;
    }

    if (widget.chatRoomId == null) {
      final chatRoomId = await _createChatRoom(senderId);
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

  Future<String> _createChatRoom(String senderId) {
    final createChatRoomUseCase = ref.read(createChatRoomUseCaseProvider);
    return createChatRoomUseCase(widget.otherUserId, senderId, widget.productID);
  }

  Future<void> _sendContent(String chatRoomId, String senderId, String content) async {
    final sendChatMessageUseCase = ref.read(sendChatMessageUseCaseProvider);

    await sendChatMessageUseCase(
        chatRoomId, ChatMessageType.location, content, senderId);
  }
}

final _searchResultProvider = FutureProvider.family<List<AutocompletePrediction>, String>((ref, input) {
  final mapUseCase = ref.read(mapUseCaseProvider);
  return mapUseCase.getPredictions(input);
});

final _currentTargetProvider = StateProvider.autoDispose<AsyncValue<NLatLng>>((ref) {
  return const AsyncLoading();
});

final _currentAddressProvider = FutureProvider.autoDispose<Placemark?>((ref) {
  final target = ref.watch(_currentTargetProvider);
  final mapUseCase = ref.read(mapUseCaseProvider);

  return target.when(
    data: (data) => mapUseCase.transAddressFromGeo(data),
    error: (error, stackTrace) => Future.error(error),
    loading: () => Future.delayed(const Duration(days: 365)),
  );
});
