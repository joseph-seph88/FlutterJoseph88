import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import '../../providers/map_provider.dart';

class AddShopPage extends ConsumerStatefulWidget {
  const AddShopPage({super.key});

  @override
  ConsumerState<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends ConsumerState<AddShopPage> {
  final _searchController = TextEditingController();
  final _searchController2 = TextEditingController();
  NaverMapController? _mapController;
  Placemark? placeAddress = const Placemark(street: "Default");
  NLatLng centerLatLng = const NLatLng(37.499889, 126.920056);
  final iconPath = 'assets/icons/coffee.png';

  void _moveCamera() async {
    final cameraUpdate = NCameraUpdate.fromCameraPosition(
      const NCameraPosition(
        target: NLatLng(37.499889, 126.920056),
        zoom: 16,
      ),
    );
    await _mapController!.updateCamera(cameraUpdate);
  }

  void _convertPositionToAddress() async {
    if (_mapController == null) return;
    final cameraPosition = await _mapController!.getCameraPosition();
    centerLatLng = cameraPosition.target;
    final newPlaceAddress =
        await ref.read(mapProvider.notifier).transAddressFromGeo(centerLatLng);
    setState(() {
      placeAddress = newPlaceAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 40,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
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
                          setState(() {
                            _mapController = controller;
                          });
                        },
                        onCameraIdle: () {
                          _convertPositionToAddress();
                        },
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 5.8,
                      left: MediaQuery.of(context).size.width / 2.8,
                      child: Image.asset(
                        'assets/icons/location.png',
                        width: 80,
                        height: 80,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 80,
                      child: FloatingActionButton(
                        onPressed: () {
                          if (_mapController != null) {
                            _moveCamera();
                          }
                        },
                        child: const Icon(Icons.my_location),
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
                        left: AppStyles.verticalPadding.left + 5,
                      ),
                      child: placeAddress != null
                          ? Text(
                              '${placeAddress?.street}',
                              style: AppStyles.labelLarge
                                  .copyWith(color: AppColors.text),
                            )
                          : Text(
                              "Data",
                              style: AppStyles.labelLarge
                                  .copyWith(color: AppColors.text),
                            ),
                    ),
                    Container(
                      padding: AppStyles.verticalPadding.copyWith(
                        top: AppStyles.verticalPadding.top - 10,
                        bottom: AppStyles.verticalPadding.bottom - 5,
                      ),
                      child: TextField(
                        controller: _searchController2,
                        decoration: InputDecoration(
                          hintText: "(선택) 상세 주소 입력",
                          hintStyle:
                              AppStyles.labelLarge.copyWith(color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppStyles.defaultRadius),
                          ),
                          contentPadding: AppStyles.defaultPadding.copyWith(
                            top: AppStyles.verticalPadding.top - 10,
                          ),
                        ),
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
                            final position = GeoPoint(
                                centerLatLng.latitude, centerLatLng.longitude);
                            await ref
                                .read(mapProvider.notifier)
                                .addMarker(position, iconPath, centerLatLng);
                          },
                          child:
                              const Text("선택", style: AppStyles.labelLarge)),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
