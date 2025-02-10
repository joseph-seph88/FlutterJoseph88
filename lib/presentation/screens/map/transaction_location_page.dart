import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/constants/app_constant.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/widgets/custom_snack_bar.dart';
import '../../providers/map_provider.dart';

class TransactionLocationPage extends ConsumerStatefulWidget {
  const TransactionLocationPage({super.key});

  @override
  ConsumerState<TransactionLocationPage> createState() =>
      _TransactionLocationPageState();
}

class _TransactionLocationPageState
    extends ConsumerState<TransactionLocationPage> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final _searchFocusNode = FocusNode();
  NaverMapController? _mapController;
  NLatLng transactionPosition = const NLatLng(37.499889, 126.920056);
  NLatLng currentPosition = const NLatLng(37.499889, 126.920056);

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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.text,
      statusBarIconBrightness: Brightness.light,
    ));
    _textController.dispose();
    _focusNode.dispose();
    _searchFocusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _moveCamera(NLatLng nLatLng) async {
    final cameraUpdate = NCameraUpdate.fromCameraPosition(
      NCameraPosition(
        target: nLatLng,
        zoom: 16,
      ),
    );
    await _mapController?.updateCamera(cameraUpdate);
  }

  Future<void> _onCameraIdle() async {
    final position = _mapController!.nowCameraPosition;
    transactionPosition =
        NLatLng(position.target.latitude, position.target.longitude);
    await ref
        .read(mapProvider.notifier)
        .transPositionToAddress(transactionPosition);
  }

  Future<void> _onMapReady(NaverMapController controller) async {
    _mapController = controller;
    await ref
        .read(mapProvider.notifier)
        .transPositionToAddress(transactionPosition);
  }

  void _zoomIn() {
    _focusNode.unfocus();
    _mapController?.updateCamera(NCameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _focusNode.unfocus();
    _mapController?.updateCamera(NCameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: NaverMap(
                      options: NaverMapViewOptions(
                        initialCameraPosition:
                            NCameraPosition(target: currentPosition, zoom: 16),
                        extent: const NLatLngBounds(
                          southWest: NLatLng(31.43, 122.37),
                          northEast: NLatLng(44.35, 132.0),
                        ),
                      ),
                      onMapReady: (controller) async {
                        await _onMapReady(controller);
                      },
                      onCameraIdle: () async {
                        if (_mapController != null) {
                          await _onCameraIdle();
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: 0,
                    child: Column(
                      children: [
                        Container(
                          color: AppColors.surface,
                          child: TextField(
                            focusNode: _searchFocusNode,
                            onTap: () {
                              _searchFocusNode.unfocus();
                              context.push('/map/addShop/searchAddr');
                            },
                            decoration: InputDecoration(
                              hintText: "여기서 업체 검색",
                              hintStyle: AppStyles.labelLarge
                                  .copyWith(color: AppColors.textSecondary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppStyles.defaultRadius),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            style: AppStyles.labelLarge
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 4.2,
                    left: MediaQuery.of(context).size.width / 2.2,
                    child: Image.asset(
                      AppConstant.locationPath,
                      width: 80,
                      height: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 20,
                    child: ElevatedButton(
                      onPressed: () async {
                        _zoomIn();
                      },
                      child: const Icon(Icons.add, color: AppColors.surface),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: ElevatedButton(
                      onPressed: () async {
                        _zoomOut();
                      },
                      child: const Icon(Icons.remove, color: AppColors.surface),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 40,
                    child: FloatingActionButton(
                      backgroundColor: AppColors.primary,
                      onPressed: () async {
                        if (_mapController != null) {
                          _focusNode.unfocus();
                          await _moveCamera(currentPosition);
                        }
                      },
                      child: const Icon(Icons.my_location,
                          color: AppColors.surface),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: AppStyles.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: AppStyles.verticalPadding.copyWith(
                      top: AppStyles.verticalPadding.top - 10,
                      bottom: AppStyles.verticalPadding.bottom - 10,
                      left: AppStyles.verticalPadding.left + 20,
                    ),
                    child: Text(
                      mapState.transAddress,
                      style:
                          AppStyles.labelLarge.copyWith(color: AppColors.text),
                    ),
                  ),
                  Container(
                    padding: AppStyles.verticalPadding.copyWith(
                      top: AppStyles.verticalPadding.top - 10,
                      bottom: AppStyles.verticalPadding.bottom - 10,
                    ),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      onTap: () {
                        if (_focusNode.hasFocus) {
                          _focusNode.unfocus();
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "상세 주소 입력",
                          hintText: "상수 주소 입력",
                          hintStyle:
                              AppStyles.labelLarge.copyWith(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.storefront,
                            color: AppColors.textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppStyles.defaultRadius),
                          ),
                          contentPadding: AppStyles.defaultPadding.copyWith(
                              top: AppStyles.verticalPadding.top - 10,
                              bottom: AppStyles.verticalPadding.bottom - 10)),
                      style: AppStyles.labelLarge.copyWith(color: Colors.black),
                    ),
                  ),
                  Container(
                    padding: AppStyles.verticalPadding.copyWith(
                      top: AppStyles.verticalPadding.top - 10,
                      bottom: AppStyles.verticalPadding.bottom - 10,
                    ),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          _focusNode.unfocus();
                          if (_textController.text.isNotEmpty) {
                            ref
                                .read(transactionLocationProvider.notifier)
                                .state = {
                              'address': mapState.transAddress,
                              'position': transactionPosition,
                              'detail': mapState.positionData,
                            };
                            context.pop();
                          } else {
                            CustomSnackBar.customSnackBar(
                                context, "상세 주소를 입력하세요.");
                          }
                        },
                        child:
                            const Text("거래장소 선택", style: AppStyles.labelLarge)),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
