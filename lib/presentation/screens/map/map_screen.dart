import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _searchController = TextEditingController();
  late NaverMapController _mapController;

  final List<Map<String, dynamic>> iconData = [
    {"name": "아지트", "icon": Icons.star, "color": Colors.blue},
    {"name": "커피샵", "icon": Icons.home, "color": Colors.brown},
    {"name": "음식점", "icon": Icons.favorite, "color": Colors.green},
    {"name": "뷰티", "icon": Icons.search, "color": Colors.orange},
    {"name": "미용실", "icon": Icons.access_alarm, "color": Colors.deepPurple},
    {"name": "다이소", "icon": Icons.camera, "color": Colors.red},
    {"name": "운동", "icon": Icons.accessibility, "color": Colors.yellow},
    {"name": "취미", "icon": Icons.airplanemode_active, "color": Colors.pink},
    {"name": "타코야끼", "icon": Icons.account_balance, "color": Colors.cyan},
    {"name": "붕어빵", "icon": Icons.account_circle, "color": Colors.teal},
  ];

  final List<Map<String, dynamic>> markerData = [
    {
      "id": "1",
      "position": const NLatLng(37.499889, 126.920056),
      "address": "보라매역"
    },
    {
      "id": "2",
      "position": const NLatLng(37.498306, 126.948045),
      "address": "보라매공원"
    },
    {
      "id": "3",
      "position": const NLatLng(37.490033, 126.952046),
      "address": "대림역"
    },
    {
      "id": "4",
      "position": const NLatLng(37.499533, 126.943524),
      "address": "삼성생명빌딩"
    },
    {
      "id": "5",
      "position": const NLatLng(37.494521, 126.948514),
      "address": "서울아트센터"
    },
    {
      "id": "6",
      "position": const NLatLng(37.489247, 126.949136),
      "address": "서울과학기술대학교"
    },
    {
      "id": "7",
      "position": const NLatLng(37.497115, 126.944978),
      "address": "서울대학교병원"
    },
    {
      "id": "8",
      "position": const NLatLng(37.493748, 126.941469),
      "address": "이수역"
    },
    {
      "id": "9",
      "position": const NLatLng(37.495808, 126.946205),
      "address": "대림미술관"
    },
    {
      "id": "10",
      "position": const NLatLng(37.492052, 126.948716),
      "address": "신림역 (근처)"
    }
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(12),
            height: 220,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    context.push('/likeShop');
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.heart_broken,
                          size: 30,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 28),
                      const Text("업체 후기"),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                TextButton(
                  onPressed: () {
                    context.push('/addShop');
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.orange,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 28),
                      const Text("업체 추가"),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _moveCameraToMarker(int index) async {
    final targetLocation = markerData[index]['position'];
    final cameraUpdate = NCameraUpdate.fromCameraPosition(
      NCameraPosition(
        target: targetLocation,
        zoom: 15,
      ),
    );
    await _mapController.updateCamera(cameraUpdate);
  }

  // void _addMarkers() async {
  //   NMarker marker = NMarker(
  //     id: "1",
  //     position: const NLatLng(37.499889, 126.920056),
  //   );
  //   await _mapController.addOverlay(marker);
  //
  // }

  void _addAllMarkers() async {
    Set<NAddableOverlay> markers = {};

    for (var data in markerData) {
      NMarker marker = NMarker(
        id: data['id'],
        position: data['position'],
      );
      final infoWindow = NInfoWindow.onMarker(
        id: marker.info.id,
        text: data['address'],
      );
      marker.setOnTapListener((NMarker tappedMarker) {
        tappedMarker.openInfoWindow(infoWindow);
      });
      markers.add(marker);
    }
    await _mapController.addOverlayAll(markers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        NaverMap(
          options: const NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
                target: NLatLng(37.499889, 126.920056), zoom: 15),
          ),
          onMapReady: (controller) {
            _mapController = controller;
            _addAllMarkers();
          },
        ),
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Container(
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "여기서 업체 검색",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 120,
            left: 20,
            child: ElevatedButton(
                onPressed: () {
                  _moveCameraToMarker(0);
                },
                child: const Icon(Icons.my_location))),
        Positioned(
          bottom: 120,
          right: 20,
          child: FloatingActionButton.extended(
              onPressed: () {
                showBottomSheet(context);
              },
              label: const Row(
                children: [Icon(Icons.add), Text("추가하기")],
              )),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.1,
          minChildSize: 0.1,
          maxChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: const Row(
                      children: [
                        Icon(Icons.location_on),
                        Text("영등포구 보라매역 공원"),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: GridView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: iconData.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                iconData[index]['icon'],
                                color: iconData[index]['color'],
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              iconData[index]['name'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));
  }
}
