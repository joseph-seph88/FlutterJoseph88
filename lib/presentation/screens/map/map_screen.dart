import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:o2/core/constants/app_constant.dart';
import 'package:o2/core/theme/app_theme.dart';
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
  final _searchController = TextEditingController();
  Set<NMarker> markersSet = {};
  String? shortAddress = "영등포구 보라매역 공원";
  NCameraPosition position =
      const NCameraPosition(target: NLatLng(37.499889, 126.920056), zoom: 15);
  NLatLng selectedLatLng = const NLatLng(37.499889, 126.920056);
  List<Map<String, dynamic>> iconData = [];
  List<MapEntity> mapDataList = [];
  double _buttonOffset = 120;
  List<MapEntity> searchDataList = [];
  bool toggled = false;
  String iconDataPath = AppConstant.fishPath;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppConstant.transparentColor,
      statusBarIconBrightness: Brightness.dark,
    ));
    _sheetController = DraggableScrollableController();
    _sheetController.addListener(() {
      setState(() {
        double sheetHeight = MediaQuery.of(context).size.height * 0.8;
        _buttonOffset = 120 + (_sheetController.size * sheetHeight);
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppConstant.blackColor,
      statusBarIconBrightness: Brightness.light,
    ));
    _searchController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void onButtonPressed(String iconPath, GeoPoint geoPosition) {
    ref.read(mapParamProvider.notifier).state = {
      'iconPath': iconPath,
      'position': geoPosition
    };
  }

  Future<void> updateMapMarkers(List<MapEntity> markers) async {
    markersSet.clear();
    await _mapController?.clearOverlays(type: NOverlayType.marker);

    for (var marker in markers) {
      final streamMarker = NMarker(
          id: marker.mapId ?? '1',
          position:
              NLatLng(marker.position.latitude, marker.position.longitude),
          icon: NOverlayImage.fromAssetImage(marker.iconPath),
          iconTintColor: Colors.green,
          size: const NSize(20, 20));

      streamMarker.setOnTapListener((overlay) async {
        final infoWindow = NInfoWindow.onMarker(
          id: marker.mapId ?? '1',
          text: marker.address,
        );

        bool isOpen = await streamMarker.hasOpenInfoWindow();
        if (!isOpen) {
          await streamMarker.openInfoWindow(infoWindow);
        }
      });
      markersSet.add(streamMarker);
    }
    await _mapController?.addOverlayAll(markersSet);
  }

  Future<void> addOverlayMarkers(int index) async {
    await _mapController?.clearOverlays(type: NOverlayType.marker);
    markersSet.clear();

    if (mapDataList.isNotEmpty) {
      for (var mapEntity in mapDataList) {
        final marker = NMarker(
          id: mapEntity.mapId ?? '1',
          position: NLatLng(
              mapEntity.position.latitude, mapEntity.position.longitude),
          icon: NOverlayImage.fromAssetImage(mapEntity.iconPath),
          size: const NSize(30, 30),
          iconTintColor: iconData[index]['color'],
        );

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
        markersSet.add(marker);
      }
      await _mapController?.addOverlayAll(markersSet);
    }
  }

  Future<void> addOverlayMarker(MapEntity storeData) async {
    await _mapController?.clearOverlays(type: NOverlayType.marker);

    final marker = NMarker(
      id: storeData.mapId ?? '1',
      position:
          NLatLng(storeData.position.latitude, storeData.position.longitude),
      icon: NOverlayImage.fromAssetImage(storeData.iconPath),
      size: const NSize(30, 30),
      iconTintColor: Colors.green,
    );

    await _mapController?.addOverlay(marker);

    setState(() {
      toggled = false;
      _searchController.clear();
    });
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

  Future<void> searchStore(String inputText) async {
    List<MapEntity> searchData =
        await ref.watch(mapProvider.notifier).searchStore(inputText);
    setState(() {
      searchDataList = searchData;
    });
  }

  void moveCamera(NLatLng nLatLng) async {
    final cameraUpdate = NCameraUpdate.fromCameraPosition(
      NCameraPosition(
        target: nLatLng,
        zoom: 16,
      ),
    );
    await _mapController?.updateCamera(cameraUpdate);
  }

  Future<void> addCircleOverlay(NLatLng latLng) async {
    const double radius = 190.0;
    final circleOverlay = NCircleOverlay(
        id: "circle",
        center: latLng,
        radius: radius,
        color: const Color.fromRGBO(169, 169, 169, 0.5));

    await _mapController?.addOverlay(circleOverlay);
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);

    ref.listen<AsyncValue<List<MapEntity>>>(
      mapDataStreamProvider,
      (previous, next) {
        next.when(
          data: (newData) async {
            setState(() {
              mapDataList.clear();
              mapDataList.addAll(newData);
            });
            await updateMapMarkers(newData);
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
              setState(() {
                _mapController = controller;
              });
              final overlay = controller.getLocationOverlay();
              overlay.setIsVisible(true);
              ref.read(mapProvider.notifier).getIconDataList;
              iconData = ref.read(mapProvider).iconDataList;
              if (_mapController != null) {
                position = await _mapController!.getCameraPosition();
              }
            },
            onCameraIdle: () async {
              if (_mapController != null) {
                position = await _mapController!.getCameraPosition();
                print(
                    "카메라이동시좌표: ${position.target.latitude} / ${position.target.longitude}");
                if (position.target.latitude != 0) {
                  final latLng = NLatLng(
                      position.target.latitude, position.target.longitude);
                  await addCircleOverlay(latLng);
                  final param = {
                    'iconPath': iconDataPath,
                    'position': GeoPoint(
                        position.target.latitude, position.target.longitude)
                  };

                  ref.watch(mapParamProvider.notifier).state = param;
                }
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
                    onTap: () async {
                      setState(() {
                        toggled = true;
                      });
                    },
                    onChanged: (text) async {
                      if (text.isNotEmpty) {
                        await searchStore(text);
                      } else {
                        setState(() {
                          searchDataList = [];
                        });
                      }
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
                    style: AppStyles.labelLarge.copyWith(color: Colors.black),
                  ),
                ),
                if (toggled)
                  SingleChildScrollView(
                    child: Container(
                      color: AppColors.primary.withAlpha(150).withRed(150),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchDataList.length,
                        itemBuilder: (context, index) {
                          final store = searchDataList[index];
                          return ListTile(
                            title: Text(store.storeName),
                            subtitle: Text(store.address),
                            onTap: () async {
                              selectedLatLng = NLatLng(
                                  searchDataList[index].position.latitude,
                                  searchDataList[index].position.longitude);
                              moveCamera(selectedLatLng);
                              await addOverlayMarker(store);
                            },
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
              bottom: _buttonOffset,
              left: 20,
              child: ElevatedButton(
                  onPressed: () {
                    selectedLatLng = const NLatLng(37.499889, 126.920056);
                    moveCamera(selectedLatLng);
                  },
                  child: const Icon(Icons.my_location))),
          Positioned(
            bottom: _buttonOffset,
            right: 20,
            child: FloatingActionButton.extended(
                onPressed: () async{
                  await ref.read(mapProvider.notifier).getStoreData();
                  final customBottomSheet = ref.read(bottomSheetProvider);
                  if(context.mounted){
                    customBottomSheet.bottomSheetWithTwoBtn(context);
                  }
                },
                label: const Row(
                  children: [
                    Icon(Icons.add),
                    Text("추가하기", style: AppStyles.labelMedium)
                  ],
                )),
          ),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.45,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  color: AppColors.surface,
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
                                : Text(
                                    '보라매역',
                                    style: AppStyles.labelLarge
                                        .copyWith(color: AppColors.text),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: iconData.length,
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
                                    final geoPosition = GeoPoint(
                                        position.target.latitude,
                                        position.target.longitude);
                                    iconDataPath = iconData[index]['icon'];
                                    final param = {
                                      'iconPath': iconDataPath,
                                      'position': geoPosition
                                    };
                                    ref.watch(mapParamProvider.notifier).state =
                                        param;
                                    onButtonPressed(
                                        iconData[index]['icon'], geoPosition);
                                  },
                                  child: Column(
                                    children: [
                                      ImageIcon(
                                        AssetImage(iconData[index]['icon']),
                                        size: 30,
                                        color: iconData[index]['color'],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        iconData[index]['label'],
                                        style: AppStyles.labelMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              );
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