import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/screens/map/widgets/map_stream_search.dart';
import 'package:o2/presentation/screens/map/widgets/scroll_view_in_bottom_sheet.dart';
import 'package:o2/presentation/screens/map/widgets/store_search_result.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/map_entity.dart';
import '../../providers/map_provider.dart';
import '../../providers/permission_provider.dart';

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
  double _buttonOffset = 100;
  bool _isSearching = false;
  NLatLng myPosition = const NLatLng(37.5547, 126.9706);

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



  void _zoomIn() {
    _mapController?.updateCamera(NCameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.updateCamera(NCameraUpdate.zoomOut());
  }

  NaverMapViewOptions _initMap() {
    return NaverMapViewOptions(
      initialCameraPosition: NCameraPosition(target: myPosition, zoom: 15),
      extent: const NLatLngBounds(
        southWest: NLatLng(31.43, 122.37),
        northEast: NLatLng(44.35, 132.0),
      ),
    );
  }

  void _onMapReady(NaverMapController controller) {
    _mapController = controller;
    if (_mapController != null) {
      final nLatLng = _mapController!.nowCameraPosition.target;
      final overlay = controller.getLocationOverlay();
      overlay.setIsVisible(true);
      ref.read(mapProvider.notifier).getAllMapData(nLatLng);
      ref.read(mapProvider.notifier).getStaticCategoryData;
      ref.read(mapProvider.notifier).updateTargetPosition(nLatLng);
      ref.read(isStreamProvider.notifier).state = false;
    }
  }

  void _onCameraIdle() {
    if (_mapController != null) {
      _mapController?.clearOverlays(type: NOverlayType.circleOverlay);
      final nPosition = _mapController?.nowCameraPosition.target;
      ref.read(mapProvider.notifier).updateTargetPosition(nPosition!);

      if (ref.read(isStreamProvider)) {
        addCircleOverlay(nPosition);
        final geoPosition = GeoPoint(nPosition.latitude, nPosition.longitude);
        final category = ref.read(categoryProvider);
        final param = {'category': category, 'position': geoPosition};
        ref.read(mapParamProvider.notifier).state = param;
      }
    }
  }

  void _textFieldOnChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    ref.read(mapProvider.notifier).updateStoreList(value);
  }

  Future<void> _searchResultOnTap(MapEntity storeData) async {
    await _mapController?.clearOverlays(type: NOverlayType.marker);
    ref.read(isStreamProvider.notifier).state = false;
    _searchController.clear();

    final nLatLng =
        NLatLng(storeData.position.latitude, storeData.position.longitude);
    final nMarker =
        await ref.read(mapProvider.notifier).setMapMarker(storeData);
    await _mapController?.addOverlay(nMarker);

    ref.read(mapProvider.notifier).updateTargetPosition(nLatLng);
    final cameraUpdate = NCameraUpdate.withParams(target: nLatLng)
      ..setAnimation(animation: NCameraAnimation.fly);
    _mapController?.updateCamera(cameraUpdate);

    setState(() {
      _isSearching = false;
    });
  }

  void _moveMyPosition() {
    if (_mapController != null) {
      final cameraUpdate = NCameraUpdate.withParams(target: myPosition)
        ..setAnimation(animation: NCameraAnimation.fly);

      _mapController?.updateCamera(cameraUpdate);
    }
  }

  Future<void> _radiusSearchOnButton(
      String category, ScrollController scrollController) async {
    await _mapController?.clearOverlays(type: NOverlayType.marker);
    final nPosition = _mapController?.nowCameraPosition.target;
    if (nPosition != null) {
      final geoPosition = GeoPoint(nPosition.latitude, nPosition.longitude);
      final param = {'category': category, 'position': geoPosition};
      ref.read(isInitProvider.notifier).state = true;
      ref.read(mapParamProvider.notifier).state = param;
      await addCircleOverlay(nPosition);

      setState(() {
        _sheetController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    }
  }

  Future<void> addCircleOverlay(NLatLng latLng) async {
    const double radius = 220.0;
    final circleOverlay = NCircleOverlay(
      id: "circle",
      center: latLng,
      radius: radius,
      color: AppColors.textSecondary.withAlpha(80),
    );
    await _mapController?.addOverlay(circleOverlay);
  }

  Future<void> streamUpdateMarkers(List<MapEntity> mapDataList) async {
    await _mapController?.clearOverlays(type: NOverlayType.marker);
    ref.read(mapProvider.notifier).clearMapMarkers();

    await ref.read(mapProvider.notifier).setMapMarkers(mapDataList);
    final markerSetData = ref.read(mapProvider).markersSet;

    if (markerSetData.isNotEmpty) {
      await _mapController?.addOverlayAll(markerSetData);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(locationPermissionProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          NaverMap(
              options: _initMap(),
              onMapReady: (controller) => _onMapReady(controller),
              onCameraIdle: _onCameraIdle),

          // if(ref.watch(isStreamProvider))
          MapStateListener((List<MapEntity> mapDataList) async {
            streamUpdateMarkers(mapDataList);
          }),

          Positioned(
            top: 50,
            left: 20,
            right: 20,
            bottom: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: '여기서 업체 검색',
                      hintStyle: AppStyles.labelLarge
                          .copyWith(color: AppColors.textSecondary),
                      filled: true,

                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    onChanged: (value) => _textFieldOnChanged(value),
                    onTapOutside: (_) => _focusNode.unfocus(),
                    onTap: (){
                      setState(() {
                        _sheetController.animateTo(0,
                            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                if (_isSearching) ...[
                  StoreSearchResult(
                    (MapEntity storeData) async {
                      _searchResultOnTap(storeData);
                    },
                  )
                ],
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
              onPressed: _moveMyPosition,
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
                    _isSearching = false;
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
                return GestureDetector(
                  onVerticalDragUpdate: (details) {
                    final newOffset = (_sheetController.size -
                            details.primaryDelta! /
                                MediaQuery.of(context).size.height)
                        .clamp(0.0, 1.0);
                    _sheetController.jumpTo(newOffset);
                  },
                  child: ScrollViewInBottomSheet(scrollController,
                      (String category) async {
                    _radiusSearchOnButton(category, scrollController);
                  }),
                );
              }),
        ],
      ),
    );
  }
}
