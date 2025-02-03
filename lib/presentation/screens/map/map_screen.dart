import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:o2/core/constants/app_constant.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/widgets/show_bottom_sheet.dart';
import '../../providers/map_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late NaverMapController _mapController;
  late NLatLng _latLng;
  final _searchController = TextEditingController();
  Set<NMarker> markers = {};
  String? shortAddress = "영등포구 보라매역 공원";

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppConstant.transparentColor,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppConstant.blackColor,
      statusBarIconBrightness: Brightness.light,
    ));
    _searchController.dispose();
    super.dispose();
  }

  void moveCamera() async {
    final cameraUpdate = NCameraUpdate.fromCameraPosition(
      const NCameraPosition(
        target: NLatLng(37.499889, 126.920056),
        zoom: 15,
      ),
    );
    await _mapController.updateCamera(cameraUpdate);
  }

  String? getFormattedAddress(Placemark? placeAddress) {
    if (placeAddress?.street == null) return null;
    String fullAddress = placeAddress!.street!;
    List<String> parts = fullAddress.split(' ');
    if (parts.length >= 3) {
      return parts.sublist(parts.length - 3).join(' ');
    }
    return fullAddress;
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);

    Future<void> onMapTapped(NPoint point, NLatLng latLng) async {
      final defaultIconPath =
          NOverlayImage.fromAssetImage(mapState.defaultIconPath);
      _latLng = latLng;
      final placeAddress =
          await ref.read(mapProvider.notifier).transAddressFromGeo(_latLng);
      shortAddress = getFormattedAddress(placeAddress);

      final tempMarker = NMarker(
        id: 'default',
        position: _latLng,
        icon: defaultIconPath,
        iconTintColor: AppColors.primary,
        size: const NSize(30, 30),
        caption: placeAddress != null
            ? NOverlayCaption(text: '$shortAddress')
            : const NOverlayCaption(text: "Unknown"),
      );
      await _mapController.addOverlay(tempMarker);
    }

    // void addMarker() async {
    //   const iconPath = 'assets/icons/coffee.png';
    //   final geoPosition = GeoPoint(_latLng.latitude, _latLng.longitude);
    //   final markerData = NMarker(
    //     id: '${_latLng.latitude}_${_latLng.longitude}',
    //     position: _latLng,
    //     icon: const NOverlayImage.fromAssetImage(iconPath),
    //     size: const NSize(30, 30),
    //   );
    //   await _mapController.addOverlay(markerData);
    //   await ref
    //       .read(mapProvider.notifier)
    //       .addMarker(geoPosition, iconPath, _latLng);
    // }

    // Future<void> addMarkersDistance() async {
    //   const geoPosition = GeoPoint(37.499889, 126.920056);
    //   await ref.read(mapProvider.notifier).getMarkers(geoPosition);
    //   final mapState = ref.read(mapProvider);
    //   await _mapController.clearOverlays();
    //   markers.clear();
    //
    //   if (mapState.mapDataList.isNotEmpty) {
    //     for (var mapEntity in mapState.mapDataList) {
    //       final marker = NMarker(
    //           id: mapEntity.mapId ?? '1',
    //           position: NLatLng(
    //               mapEntity.position.latitude, mapEntity.position.longitude),
    //           icon: NOverlayImage.fromAssetImage(mapEntity.iconPath),
    //           size: const NSize(20, 20),
    //           iconTintColor: AppConstant.indigoColor);
    //
    //       marker.setOnTapListener((overlay) async {
    //         final infoWindow = NInfoWindow.onMarker(
    //           id: mapEntity.mapId ?? '1',
    //           text: mapEntity.address,
    //         );
    //
    //         bool isOpen = await marker.hasOpenInfoWindow();
    //         if (!isOpen) {
    //           await marker.openInfoWindow(infoWindow);
    //         }
    //       });
    //       markers.add(marker);
    //     }
    //     await _mapController.addOverlayAll(markers);
    //   }
    // }

    Future<void> addMarkersToMap(int index, List<Map<String, dynamic>> iconDataList) async {
      await ref
          .read(mapProvider.notifier)
          .getMapDataWithIcon(iconDataList[index]['icon']);
      final mapState = ref.read(mapProvider);
      await _mapController.clearOverlays();
      markers.clear();

      if (mapState.mapDataList.isNotEmpty) {
        for (var mapEntity in mapState.mapDataList) {
          final marker = NMarker(
              id: mapEntity.mapId ?? '1',
              position: NLatLng(
                  mapEntity.position.latitude, mapEntity.position.longitude),
              icon: NOverlayImage.fromAssetImage(mapEntity.iconPath),
              size: const NSize(20, 20),
              iconTintColor: iconDataList[index]['color']);

          marker.setOnTapListener((overlay) async {
            final infoWindow = NInfoWindow.onMarker(
              id: mapEntity.mapId ?? '1',
              text: mapEntity.address,
            );

            bool isOpen = await marker.hasOpenInfoWindow();
            if (!isOpen) {
              await marker.openInfoWindow(infoWindow);
            }
          });
          markers.add(marker);
        }
        await _mapController.addOverlayAll(markers);
      }
    }

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
              _mapController = controller;
              final overlay = controller.getLocationOverlay();
              overlay.setIsVisible(true);
            },
            onMapTapped: (NPoint point, NLatLng latLng) async {
              await onMapTapped(point, latLng);
            },
            onCameraIdle: () async{
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              color: AppColors.surface,
              child: TextField(
                controller: _searchController,
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
                style: AppStyles.labelLarge.copyWith(color: Colors.black),
              ),
            ),
          ),
          Positioned(
              bottom: 120,
              left: 20,
              child: ElevatedButton(
                  onPressed: moveCamera, child: const Icon(Icons.my_location))),
          Positioned(
            bottom: 120,
            right: 20,
            child: FloatingActionButton.extended(
                onPressed: () {
                  final customBottomSheet = ref.read(bottomSheetProvider);
                  customBottomSheet.bottomSheetWithTwoBtn(context);
                },
                label: const Row(
                  children: [
                    Icon(Icons.add),
                    Text("추가하기", style: AppStyles.labelMedium)
                  ],
                )),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              final iconDataList = ref.read(mapProvider).iconDataList;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: AppStyles.defaultPadding.copyWith(
                        top: AppStyles.verticalPadding.top + 10,
                        bottom: AppStyles.verticalPadding.bottom + 10,
                      ),
                      color: AppColors.surface,
                      child: Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 5),
                          shortAddress != null
                              ? Text(
                                  '$shortAddress',
                                  style: AppStyles.labelLarge
                                      .copyWith(color: AppColors.text),
                                )
                              : Text('보라매역',
                                  style: AppStyles.labelLarge
                                      .copyWith(color: AppColors.text)),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: GridView.builder(
                        controller: scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: iconDataList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: AppColors.textSecondary,
                                shape: BoxShape.circle,
                              ),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await addMarkersToMap(index, iconDataList);
                                  },
                                  child: Column(
                                    children: [
                                      ImageIcon(
                                        AssetImage(iconDataList[index]['icon']),
                                        size: 30,
                                        color: iconDataList[index]['color'],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        iconDataList[index]['label'],
                                        style: AppStyles.labelMedium,
                                      ),
                                    ],
                                  )));
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
