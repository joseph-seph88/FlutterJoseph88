import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/widgets/custom_snack_bar.dart';
import '../../../core/constants/app_constant.dart';
import '../../../core/utils/color_trans_util.dart';
import '../../providers/map_provider.dart';

class AddShopPage extends ConsumerStatefulWidget {
  const AddShopPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddShopPageState();
  }
}

class _AddShopPageState extends ConsumerState<AddShopPage> {
  final _searchController = TextEditingController();
  final _storeTextController = TextEditingController();
  NaverMapController? _mapController;
  NLatLng myPosition = const NLatLng(37.499889, 126.920056);
  bool _isSearching = false;
  Map<String, dynamic> category = {};
  int? selectedIndex;
  Color? categoryColor;
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
    if (_mapController != null) {
      _mapController?.dispose();
    }
    _searchController.dispose();
    _storeTextController.dispose();
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
      final overlay = controller.getLocationOverlay();
      overlay.setIsVisible(true);
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

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final categories = mapState.staticCategory;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(onPressed: () {
          context.pop();
        }, icon: const Icon(Icons.arrow_back_ios)),
      title: const Text("등록 할 업체를 선택하세요.", style: AppStyles.labelLarge,),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
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
                    top: 10,
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
          ),
          Container(
            padding: AppStyles.defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: PopupMenuButton(
                        onSelected: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                          category = {
                            'category': categories[index]['category'],
                            'iconPath': categories[index]['iconPath'],
                            'iconColor': categories[index]['iconColor'],
                          };
                        },
                        itemBuilder: (context) {
                          return List.generate(
                            categories.length,
                            (index) {
                              category = categories[index];
                              categoryColor = ColorTransUtil.transStringToColor(
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
                                    categories[selectedIndex!]['iconColor']),
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
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: TextField(
                          controller: _storeTextController,
                          decoration: InputDecoration(
                            labelText: "상세 주소 입력",
                            hintText: "상수 주소 입력",
                            hintStyle: AppStyles.labelLarge
                                .copyWith(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppStyles.defaultRadius),
                            ),
                          ),
                          style: AppStyles.labelLarge
                              .copyWith(color: Colors.black),
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (selectedIndex != null &&
                            _storeTextController.text.isNotEmpty) {
                          final position = mapState.asyncTargetPosition;
                          final address = mapState.asyncTransAddress;
                          final storeName = _storeTextController.text;

                          position.when(data: (data) async {
                            await address.when(data: (addressData) async {
                              await ref.read(mapProvider.notifier).addMarker(
                                  data, category, addressData, storeName);
                              ref.read(isInitProvider.notifier).state = false;
                              if (context.mounted) {
                                context.pop();
                              }
                            }, error: (error, stackTrace) {
                              print('주소를 불러오는데 오류가 발생했습니다');
                            }, loading: () {
                              print('주소 로딩 중...');
                            });
                          }, error: (error, stackTrace) {
                            print('주소를 불러오는데 오류가 발생했습니다');
                          }, loading: () {
                            print('주소 로딩 중...');
                          });
                        } else {
                          CustomSnackBar.customSnackBar(
                              context: context,
                              message: "카테고리 선택 및 상세 주소를 입력하세요");
                          _storeTextController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstant.lightGreen),
                      child: Text("업체 등록",
                          style: AppStyles.labelLarge
                              .copyWith(color: AppColors.surface))),
                ),
              ],
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
          hintText: '여기서 업체 검색',
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
    const double height = 120;

    return Transform.translate(
      offset: const Offset(0, -0.4 * height),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
    );
  }

  Widget _buildInfoWindowText(String address) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      child: Text(
        address,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSearchResult(String input) {
    final mapState = ref.watch(mapProvider);

    return Container(
      height: 200,
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
