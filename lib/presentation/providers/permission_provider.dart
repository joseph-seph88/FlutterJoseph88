import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/utils/permission_manager.dart';


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