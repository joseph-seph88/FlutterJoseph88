import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import '../../../core/constants/app_constant.dart';
import '../../../domain/entities/chat_message.dart';
import '../../providers/auth_provider.dart';
import '../../providers/map_provider.dart';
import '../../providers/providers.dart';

class SendLocationPage extends ConsumerStatefulWidget {
  final String? chatRoomId;
  final String otherUserId;
  final String productID;

  const SendLocationPage({
    super.key,
    required this.chatRoomId,
    required this.otherUserId,
    required this.productID,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SendLocationPageState();
  }
}

class _SendLocationPageState extends ConsumerState<SendLocationPage> {
  final _searchController = TextEditingController();
  NaverMapController? _mapController;
  NLatLng myPosition = const NLatLng(37.499889, 126.920056);
  bool _isSearching = false;
  bool _isInfoWindowPressed = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.backgroundTransparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    if (_mapController != null) {
      _mapController?.dispose();
    }
    _searchController.dispose();
    super.dispose();
  }

  NaverMapViewOptions initMap() {
    return const NaverMapViewOptions(
      extent: NLatLngBounds(
        southWest: NLatLng(31.43, 122.37),
        northEast: NLatLng(44.35, 132.0),
      ),
    );
  }

  void _zoomIn() {
    _mapController?.updateCamera(NCameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.updateCamera(NCameraUpdate.zoomOut());
  }

  void _onMapReady(NaverMapController controller) {
    _mapController = controller;
    if (_mapController != null) {
      ref
          .read(mapProvider.notifier)
          .updateTargetPosition(_mapController!.nowCameraPosition.target);
    }
  }

  void _onCameraIdle() {
    if (_mapController != null) {
      ref
          .read(mapProvider.notifier)
          .updateTargetPosition(_mapController!.nowCameraPosition.target);
    }
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
    return createChatRoomUseCase(
        widget.otherUserId, senderId, widget.productID);
  }

  Future<void> _sendContent(
      String chatRoomId, String senderId, String content) async {
    final sendChatMessageUseCase = ref.read(sendChatMessageUseCaseProvider);

    await sendChatMessageUseCase(
        chatRoomId, ChatMessageType.location, content, senderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          NaverMap(
            options: initMap(),
            onMapReady: (controller) {
              _onMapReady(controller);
            },
            onCameraIdle: _onCameraIdle,
          ),
          Positioned(
              top: 50,
              left: 20,
              right: 20,
              bottom: 0,
              child: Column(
                children: [
                  _buildSearchTextField(),
                  const SizedBox(height: 10),
                  if (_isSearching) ...[
                    _buildSearchResult(_searchController.text)
                  ],
                ],
              )),
          _buildCenterMarker(),
          Positioned(
            bottom: 55,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                final cameraUpdate =
                    NCameraUpdate.withParams(target: myPosition)
                      ..setAnimation(animation: NCameraAnimation.fly);
                _mapController?.updateCamera(cameraUpdate);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundTransparent),
              child: const Icon(
                Icons.my_location,
                color: AppColors.primary,
                size: 25,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: ElevatedButton(
              onPressed: _zoomIn,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundTransparent),
              child: const Icon(
                Icons.add,
                color: AppColors.primary,
                size: 25,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                _zoomOut();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundTransparent),
              child: const Icon(
                Icons.remove,
                color: AppColors.primary,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: '여기서 장소 검색',
          labelText: '여기서 장소 검색',
          hintStyle:
              AppStyles.labelLarge.copyWith(color: AppColors.textSecondary),
          focusedBorder: InputBorder.none,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              _isSearching = false;
            });
            return;
          }
          setState(() {
            _isSearching = _searchController.text.isNotEmpty;
          });
          ref.read(mapProvider.notifier).updatePredictionList(value);
        },
        onSubmitted: (_) {},
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  Widget _buildCenterMarker() {
    const double height = 200;

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
              AppConstant.locationPath,
              height: 52,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoWindow() {
    final mapState = ref.watch(mapProvider);

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
      onTap: mapState.asyncTransAddress.isLoading
          ? null
          : () {
              final target = ref.read(mapProvider).asyncTargetPosition.value;
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
        child: mapState.asyncTransAddress.when(
          data: (data) {
            return _buildInfoWindowText(data);
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

  Widget _buildSearchResult(String input) {
    final mapState = ref.watch(mapProvider);

    return Container(
      height: 300,
      color: AppColors.surface,
      child: mapState.asyncPredictionList.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final predictionData = data[index];

              return ListTile(
                title: Text(predictionData.primaryText),
                subtitle: Text(predictionData.secondaryText),
                trailing: const Icon(Icons.outbond_outlined),
                onTap: () async {
                  final latLng = await ref
                      .read(mapProvider.notifier)
                      .transPlaceIdToLatLng(predictionData.placeId);
                  if (latLng == null) return;

                  final nLatLng = NLatLng(latLng.lat, latLng.lng);
                  final cameraUpdate = NCameraUpdate.withParams(target: nLatLng)
                    ..setAnimation(animation: NCameraAnimation.fly);

                  _mapController?.updateCamera(cameraUpdate);
                  _searchController.clear();
                  setState(() {
                    _isSearching = false;
                  });
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
}
