import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/utils/permission_manager.dart';

final permissionManagerProvider = Provider((ref) => PermissionManager());

final locationPermissionProvider =
    StateNotifierProvider<LocationPermissionNotifier, LocationPermission?>((ref) {
  final permissionManagerPro = ref.watch(permissionManagerProvider);
  return LocationPermissionNotifier(permissionManagerPro);
});

class LocationPermissionNotifier extends StateNotifier<LocationPermission?>
    with WidgetsBindingObserver {
  final PermissionManager _permissionManager;

  LocationPermissionNotifier(this._permissionManager) : super(null){
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    await _permissionManager.requestLocationPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
      debugPrint("[DIDCHANGE]: 권한 재체크");
    }else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      debugPrint("[BACKGROUND]: 권한 체크 중지");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
