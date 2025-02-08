import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/constants/app_constant.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/color_trans_util.dart';
import '../../providers/map_provider.dart';

class AddShopPage extends ConsumerStatefulWidget {
  const AddShopPage({super.key});

  @override
  ConsumerState<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends ConsumerState<AddShopPage> {
  final _searchController = TextEditingController();
  final _storeTextController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _storeFocusNode = FocusNode();
  NaverMapController? _mapController;
  NLatLng currentPosition = const NLatLng(37.499889, 126.920056);
  NLatLng staticLatLng = const NLatLng(37.499889, 126.920056);
  Map<String, dynamic> category = {};
  int? selectedIndex;
  Color? categoryColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_mapController != null) {
      final position = ref.read(mapProvider).positionData;
      currentPosition = NLatLng(position.lat, position.lng);
      _moveCamera(currentPosition);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _storeTextController.dispose();
    _mapController?.dispose();
    _searchFocusNode.dispose();
    _storeFocusNode.dispose();
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
    final cameraPosition = _mapController!.nowCameraPosition;
    currentPosition = NLatLng(
        cameraPosition.target.latitude, cameraPosition.target.longitude);
    await ref
        .read(mapProvider.notifier)
        .transPositionToAddress(currentPosition);
  }

  Future<void> _onMapReady(NaverMapController controller) async {
    _mapController = controller;
    await ref
        .read(mapProvider.notifier)
        .transPositionToAddress(currentPosition);
  }

  void _zoomIn() {
    _searchFocusNode.unfocus();
    _storeFocusNode.unfocus();
    _mapController?.updateCamera(NCameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _searchFocusNode.unfocus();
    _storeFocusNode.unfocus();
    _mapController?.updateCamera(NCameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final categories = mapState.staticCategory;

    Future<void> onPressedBtn() async {
      final position =
          GeoPoint(currentPosition.latitude, currentPosition.longitude);
      final storeName = _storeTextController.text;
      await ref
          .read(mapProvider.notifier)
          .addMarker(position, category, mapState.transAddress, storeName);
      ref.read(isInitProvider.notifier).state = false;
      if (context.mounted) {
        context.pop();
      }
    }

    void onSelectedBtn(int index) {
      setState(() {
        selectedIndex = index;
      });
      category = {
        'category': categories[index]['category'],
        'iconPath': categories[index]['iconPath'],
        'iconColor': categories[index]['iconColor'],
      };
    }

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
        _storeFocusNode.unfocus();
      },
      child: Scaffold(
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
              Container(
                padding: AppStyles.defaultPadding
                    .copyWith(left: AppStyles.verticalPadding.left + 20),
                child: Text(
                  "새로 등록할 업체의 \n위치를 선택해 주세요",
                  style: AppStyles.titleLarge.copyWith(color: Colors.black),
                ),
              ),
              Container(
                padding: AppStyles.horizontalPadding
                    .copyWith(bottom: AppStyles.verticalPadding.bottom - 5),
                child: TextField(
                  focusNode: _searchFocusNode,
                  onTap: () {
                    _searchFocusNode.unfocus();
                    context.push('/map/addShop/searchAddr');
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                      hintText: "주변 건물 이름, 주소",
                      hintStyle:
                          AppStyles.labelLarge.copyWith(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppStyles.defaultRadius),
                      ),
                      contentPadding: AppStyles.defaultPadding.copyWith(
                          top: AppStyles.verticalPadding.top - 5,
                          bottom: AppStyles.verticalPadding.bottom - 5)),
                  style: AppStyles.labelLarge.copyWith(color: Colors.black),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: NaverMap(
                        options: const NaverMapViewOptions(
                          initialCameraPosition: NCameraPosition(
                              target: NLatLng(37.499889, 126.920056), zoom: 16),
                          extent: NLatLngBounds(
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
                      top: MediaQuery.of(context).size.height / 6.5,
                      left: MediaQuery.of(context).size.width / 2.5,
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
                          _zoomOut();
                        },
                        child:
                            const Icon(Icons.remove, color: AppColors.surface),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 20,
                      child: ElevatedButton(
                        onPressed: () async {
                          _zoomIn();
                        },
                        child: const Icon(Icons.add, color: AppColors.surface),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 40,
                      child: FloatingActionButton(
                        backgroundColor: AppColors.primary,
                        onPressed: () async {
                          _searchFocusNode.unfocus();
                          _storeFocusNode.unfocus();
                          if (_mapController != null) {
                            await _moveCamera(staticLatLng);
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
                    Row(
                      children: [
                        Container(
                          padding: AppStyles.verticalPadding.copyWith(
                            top: AppStyles.verticalPadding.top - 10,
                            bottom: AppStyles.verticalPadding.bottom - 5,
                            left: AppStyles.verticalPadding.left + 5,
                          ),
                          child: PopupMenuButton(
                            onSelected: (index) {
                              onSelectedBtn(index);
                            },
                            itemBuilder: (context) {
                              return List.generate(
                                categories.length,
                                (index) {
                                  category = categories[index];
                                  categoryColor =
                                      ColorTransUtil.transStringToColor(
                                          category['iconColor']);
                                  return PopupMenuItem(
                                      value: index,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            category['iconPath'],
                                            width: 20,
                                            height: 20,
                                            color: categoryColor,
                                          ),
                                        ],
                                      ));
                                },
                              );
                            },
                            child: selectedIndex != null
                                ? ImageIcon(
                                    AssetImage(
                                        categories[selectedIndex!]['iconPath']),
                                    color: ColorTransUtil.transStringToColor(
                                        categories[selectedIndex!]
                                            ['iconColor']),
                                  )
                                : Text(
                                    "카테고리",
                                    style: AppStyles.labelMedium
                                        .copyWith(color: Colors.lightGreen),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: AppStyles.verticalPadding.copyWith(
                              top: AppStyles.verticalPadding.top,
                              bottom: AppStyles.verticalPadding.bottom,
                              left: AppStyles.verticalPadding.left + 20,
                            ),
                            child: Text(
                              mapState.transAddress,
                              style: AppStyles.labelLarge
                                  .copyWith(color: AppColors.text),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: AppStyles.verticalPadding.copyWith(
                        top: AppStyles.verticalPadding.top - 10,
                        bottom: AppStyles.verticalPadding.bottom - 10,
                      ),
                      child: TextField(
                        controller: _storeTextController,
                        focusNode: _storeFocusNode,
                        onTap: () {
                          if (_storeFocusNode.hasFocus) {
                            _storeFocusNode.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "상세 주소 입력",
                            hintText: "상수 주소 입력",
                            hintStyle: AppStyles.labelLarge
                                .copyWith(color: Colors.grey),
                            prefixIcon: const Icon(
                              Icons.storefront,
                              color: AppColors.textSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppStyles.defaultRadius),
                            ),
                            contentPadding: AppStyles.defaultPadding.copyWith(
                                top: AppStyles.verticalPadding.top - 5,
                                bottom: AppStyles.verticalPadding.bottom - 5)),
                        style:
                            AppStyles.labelLarge.copyWith(color: Colors.black),
                      ),
                    ),
                    Container(
                      padding: AppStyles.verticalPadding.copyWith(
                        top: AppStyles.verticalPadding.top - 10,
                        bottom: AppStyles.verticalPadding.bottom - 10,
                      ),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            _storeFocusNode.unfocus();
                            _searchFocusNode.unfocus();
                            if (selectedIndex != null) {
                              await onPressedBtn();
                            }
                          },
                          child: const Text("선택", style: AppStyles.labelLarge)),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
