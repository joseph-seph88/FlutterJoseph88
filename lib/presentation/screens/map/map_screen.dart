import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:o2/core/utils/permission_manager.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  NMarker? _marker = NMarker(
    id: 'test',
    position: const NLatLng(37.506932467450326, 127.05578661133796),
  );

  @override
  void initState() {
    super.initState();
    PermissionManager().requestLocationPermission();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NaverMap(
      options: const NaverMapViewOptions(
        indoorEnable: true,
        locationButtonEnable: false,
        consumeSymbolTapEvents: false,
        minZoom: -20,
        initialCameraPosition: NCameraPosition(
            target: NLatLng(37.506932467450326, 127.05578661133796), zoom: 15),
      ),
      onMapReady: (controller) async {
        mapControllerCompleter.complete(controller);
        if (_marker != null) {
          controller.addOverlayAll({_marker!});
        }

        if (_marker != null) {
          NInfoWindow.onMap(
            id: _marker!.info.id,
            text: "현재 위치",
            position: _marker!.position,
          );
        }
      },
    ));
  }
}
