import 'dart:async';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/utils/permission_manager.dart';
import 'package:permission_handler/permission_handler.dart';

final mapControllerProvider =
    Provider<Completer<NaverMapController>>((ref) => Completer());

final locationPermissionProvider =
    StateNotifierProvider<LocationPermissionNotifier, PermissionStatus?>((ref) {
  final permissionManagerPro = ref.watch(permissionManagerProvider);
  return LocationPermissionNotifier(permissionManagerPro);
});

class LocationPermissionNotifier extends StateNotifier<PermissionStatus?> {
  final PermissionManager _permissionManager;

  LocationPermissionNotifier(this._permissionManager) : super(null);

  Future<void> requestPermission() async {
    await _permissionManager.requestLocationPermission();
    state = await Permission.location.status;
  }
}
