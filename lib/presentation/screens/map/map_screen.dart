import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/screens/map/widgets/map_scroll_view.dart';
import 'package:o2/presentation/screens/map/widgets/map_search_scroll_view.dart';
import '../../../domain/entities/map_entity.dart';
import '../../providers/map_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  NaverMapController? _mapController;
  late DraggableScrollableController _sheetController;
  final _focusNode = FocusNode();
  final _searchController = TextEditingController();
  NLatLng currentPosition = const NLatLng(37.499889, 126.920056);
  NLatLng myPosition = const NLatLng(37.499889, 126.920056);
  double _buttonOffset = 100;
  bool toggled = false;
  String category = "";
  bool isMoving = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.backgroundTransparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    _sheetController = DraggableScrollableController();
    _sheetController.addListener(() {
      setState(() {
        double sheetHeight = MediaQuery.of(context).size.height;
        _buttonOffset = 10 + (_sheetController.size * sheetHeight);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sheetController.dispose();
    _mapController?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> updateMapMarkers(List<MapEntity> markers) async {
    await _mapController?.clearOverlays(type: NOverlayType.marker);
    ref.read(mapProvider.notifier).clearMapMarkers();
    await ref.read(mapProvider.notifier).setMapMarkers(markers);
    final markerSetData = ref.read(mapProvider).markersSet;
    if (markerSetData.isNotEmpty) {
      await _mapController?.addOverlayAll(markerSetData);
    }
  }

  Future<void> moveCamera(NLatLng nLatLng) async {
    final cameraUpdate = NCameraUpdate.fromCameraPosition(
      NCameraPosition(
        target: nLatLng,
        zoom: 16,
      ),
    );
    await _mapController?.updateCamera(cameraUpdate);
  }

  void _zoomIn() {
    _mapController?.updateCamera(NCameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.updateCamera(NCameraUpdate.zoomOut());
  }

  Future<void> moveMyPosition(NLatLng nLatLng) async {
    await moveCamera(nLatLng);
    final param = {
      'category': category,
      'position': GeoPoint(nLatLng.latitude, nLatLng.longitude)
    };
    ref.read(mapParamProvider.notifier).state = param;
  }

  Future<void> addCircleOverlay(NLatLng latLng) async {
    const double radius = 220.0;
    final circleOverlay = NCircleOverlay(
        id: "circle",
        center: latLng,
        radius: radius,
        color: const Color.fromRGBO(169, 169, 169, 0.5));
    await _mapController?.addOverlay(circleOverlay);
  }

  Future<void> moveAndOverlayWithSearchData(MapEntity searchStoreData) async {
    await _mapController?.clearOverlays();
    isMoving = true;
    ref.read(isInitProvider.notifier).state = false;

    final searchLat = searchStoreData.position.latitude;
    final searchLng = searchStoreData.position.longitude;

    final markerData =
        await ref.read(mapProvider.notifier).setMapMarker(searchStoreData);
    if (markerData != null) {
      await _mapController?.addOverlay(markerData);
    }
    await moveCamera(NLatLng(searchLat, searchLng));
    setState(() {
      toggled = false;
      _searchController.clear();
    });

    await Future.delayed(const Duration(seconds: 1));
    ref.read(isInitProvider.notifier).state = true;
  }

  Future<void> onCameraIdle() async {
    final getPosition = _mapController!.nowCameraPosition;
    currentPosition = getPosition.target;
    category = ref.read(categoryProvider);

    if (currentPosition.latitude != 0) {
      final currentLat = currentPosition.latitude;
      final currentLng = currentPosition.longitude;
      final latLng = NLatLng(currentLat, currentLng);
      final param = {
        'category': category,
        'position': GeoPoint(currentLat, currentLng)
      };
      ref.read(mapParamProvider.notifier).state = param;
      await ref.read(mapProvider.notifier).transPositionToAddress(latLng);
    }
    await addCircleOverlay(
        NLatLng(currentPosition.latitude, currentPosition.longitude));
  }

  Future<void> onMapReady(NaverMapController controller) async {
    _mapController = controller;
    category = ref.read(categoryProvider);
    ref.read(mapProvider.notifier).getStaticCategoryData;

    if (_mapController != null) {
      final overlay = controller.getLocationOverlay();
      overlay.setIsVisible(true);
      await _mapController?.clearOverlays(type: NOverlayType.marker);
      ref.read(mapParamProvider.notifier).state = {};
      await ref
          .read(mapProvider.notifier)
          .transPositionToAddress(currentPosition);
      await ref.read(mapProvider.notifier).getAllMapData(myPosition);
    }
  }

  Future<void> setMarker(MapEntity marker) async {
    final markerData =
        await ref.read(mapProvider.notifier).setMapMarker(marker);
    if (markerData != null) {
      await _mapController?.addOverlay(markerData);
    }
  }

  Future<void> onButtonPressed(String category, GeoPoint geoPosition) async {
    await _mapController?.clearOverlays(type: NOverlayType.marker);
    isMoving = false;

    final param = {'category': category, 'position': geoPosition};

    ref.read(isInitProvider.notifier).state = true;
    ref.read(mapParamProvider.notifier).state = param;

    final nLatLng = NLatLng(geoPosition.latitude, geoPosition.longitude);
    await addCircleOverlay(nLatLng);
    setState(() {
      _sheetController.jumpTo(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);

    ref.listen<AsyncValue<List<MapEntity>>>(
      mapDataStreamProvider,
      (previous, next) {
        next.when(
          data: (newData) async {
            if (!isMoving) {
              await updateMapMarkers(newData);
            } else {
              print("스트림 데이터 무시됨 (isMoving = true)");
            }
          },
          loading: () {
            print("데이터 로딩 중...");
          },
          error: (err, stack) {
            print("스트림 에러 발생: $err");
          },
        );
      },
    );

    if (mapState.isLoading) {
      return const CircularProgressIndicator();
    }
    if (mapState.error.isNotEmpty) {
      return Text("Error: ${mapState.error}");
    }

    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                  target: NLatLng(37.499889, 126.920056), zoom: 15),
              extent: NLatLngBounds(
                southWest: NLatLng(31.43, 122.37),
                northEast: NLatLng(44.35, 132.0),
              ),
            ),
            onMapReady: (controller) async {
              await onMapReady(controller);
            },
            onCameraIdle: () async {
              if (_mapController != null &&
                  ref.read(isInitProvider) == true &&
                  isMoving == false) {
                await onCameraIdle();
              }
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            bottom: 0,
            child: Column(
              children: [
                Container(
                    color: AppColors.surface,
                    child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: (query) {
                          if (query.isEmpty) {
                            setState(() {
                              toggled = false;
                            });
                            return;
                          }
                          setState(() {
                            toggled = _searchController.text.isNotEmpty;
                          });
                          ref.read(mapProvider.notifier).searchStoreData(query);
                        },
                        decoration: InputDecoration(
                          hintText: "여기서 업체 검색",
                          hintStyle: AppStyles.labelLarge
                              .copyWith(color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppStyles.defaultRadius),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        style: AppStyles.labelLarge
                            .copyWith(color: AppColors.primary.withAlpha(200)),
                        onTapOutside: (_) => _focusNode.unfocus())),
                if (toggled)
                  MapSearchScrollView(onTap: (data) async {
                    await moveAndOverlayWithSearchData(data);
                  })
              ],
            ),
          ),
          Positioned(
            bottom: _buttonOffset + 150,
            left: 20,
            child: ElevatedButton(
              onPressed: _zoomIn,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface.withAlpha(150)),
              child: const Icon(
                Icons.add,
                color: AppColors.primary,
                size: 25,
              ),
            ),
          ),
          Positioned(
            bottom: _buttonOffset + 80,
            left: 20,
            child: ElevatedButton(
              onPressed: _zoomOut,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface.withAlpha(150)),
              child: const Icon(
                Icons.remove,
                color: AppColors.primary,
                size: 25,
              ),
            ),
          ),
          Positioned(
            bottom: _buttonOffset + 10,
            left: 20,
            child: ElevatedButton(
              onPressed: () async {
                await moveMyPosition(myPosition);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface.withAlpha(150)),
              child: const Icon(
                Icons.my_location,
                color: AppColors.primary,
                size: 25,
              ),
            ),
          ),
          Positioned(
            bottom: _buttonOffset + 10,
            right: 20,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface.withAlpha(150),
                ),
                onPressed: () {
                  final mapBottomSheet = ref.read(bottomSheetProvider);
                  _searchController.clear();
                  setState(() {
                    toggled = false;
                  });
                  mapBottomSheet.mapBottomSheetWithTwoBtn(context, ref);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: AppColors.primary,
                      size: 25,
                    ),
                    Text("추가하기",
                        style: AppStyles.labelLarge
                            .copyWith(color: AppColors.primary)),
                  ],
                )),
          ),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.45,
            builder: (context, scrollController) {
              final geoLatLng =
                  GeoPoint(currentPosition.latitude, currentPosition.longitude);
              return GestureDetector(
                onVerticalDragUpdate: (details) {
                  final newOffset = (_sheetController.size -
                          details.primaryDelta! /
                              MediaQuery.of(context).size.height)
                      .clamp(0.0, 1.0);
                  _sheetController.jumpTo(newOffset);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 30,
                        width: 65,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.drag_handle,
                            color: AppColors.primary.withAlpha(100),
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: MapScrollView(scrollController, geoLatLng,
                            onButtonPressed: (category, geoPosition) async {
                          await onButtonPressed(category, geoLatLng);
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
