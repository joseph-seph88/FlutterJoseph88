import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:go_router/go_router.dart';

class MapViewWidget extends StatelessWidget {
  const MapViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final target = GoRouterState.of(context).extra as NLatLng;

    return Scaffold(
      appBar: AppBar(title: const Text('지도')),
      body: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(target: target, zoom: 14),
        ),
        onMapReady: (controller) => _addMarker(target, controller),
      ),
    );
  }

  void _addMarker(NLatLng target, NaverMapController controller) {
    final marker = NMarker(id: 'location', position: target);
    controller.addOverlay(marker);
  }
}
