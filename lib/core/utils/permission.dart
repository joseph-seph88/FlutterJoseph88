// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:open_settings_plus/core/open_settings_plus.dart';
//
// class PermissionManager {
//   Future<void> requestLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (Platform.isAndroid) {
//       await _handleAndroidPermission(permission);
//     } else if (Platform.isIOS) {
//       await _handleIOSPermission(permission);
//     }
//   }
//
//   Future<void> _handleAndroidPermission(LocationPermission permission) async {
//     try {
//       if (permission == LocationPermission.whileInUse ||
//           permission == LocationPermission.always) {
//         debugPrint("ANDROID: 위치 권한 허용됨");
//       } else if (permission == LocationPermission.denied) {
//         var newPermission = await Geolocator.requestPermission();
//
//         if (newPermission == LocationPermission.always ||
//             newPermission == LocationPermission.whileInUse) {
//           debugPrint("ANDROID: 위치 권한 허용됨");
//         } else {
//           debugPrint("ANDROID: 위치 권한 거부됨");
//           _openSettings();
//         }
//       } else if (permission == LocationPermission.deniedForever) {
//         debugPrint("ANDROID: 위치 권한 영구적 거부됨");
//         _openSettings();
//       } else {
//         debugPrint("ANDROID: 아무튼 위치 권한 거부됨");
//       }
//     } catch (e) {
//       debugPrint("권한 요청 중 오류 발생: ${e.toString()}");
//       throw Exception("[PER]:권한 오류 ${e.toString()}");
//     }
//   }
//
//   Future<void> _handleIOSPermission(LocationPermission permission) async {
//     try {
//       if (permission == LocationPermission.whileInUse ||
//           permission == LocationPermission.always) {
//         debugPrint("IOS: 위치 권한 허용됨");
//       } else if (permission == LocationPermission.denied) {
//         debugPrint("IOS: 위치 권한 거부됨");
//         var newPermission = await Geolocator.requestPermission();
//
//         if (newPermission == LocationPermission.always ||
//             newPermission == LocationPermission.whileInUse) {
//           debugPrint("IOS: 위치 권한 허용됨");
//         } else {
//           debugPrint("iOS: 위치 권한 거부됨");
//           _openSettings();
//         }
//       } else if (permission == LocationPermission.deniedForever) {
//         debugPrint("IOS: 위치 권한 영구적으로 거부됨");
//         _openSettings();
//       } else {
//         debugPrint("iOS: 위치 권한 상태 알 수 없음");
//       }
//     } catch (e) {
//       debugPrint("iOS: 권한 요청 중 오류 발생: ${e.toString()}");
//       throw Exception("iOS: [PER]:권한 오류 ${e.toString()}");
//     }
//   }
//
//   void _openSettings(){
//     switch (OpenSettingsPlus.shared) {
//       case OpenSettingsPlusAndroid settings:
//         settings.locationSource();
//         break;
//       case OpenSettingsPlusIOS settings:
//         settings.locationServices();
//         break;
//       default:
//         throw Exception('지원되지 않는 플랫폼입니다.');
//     }
//   }
// }



//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../core/utils/permission_manager.dart';
//
// final permissionManagerProvider = Provider((ref) => PermissionManager());
//
// final locationPermissionProvider =
// StateNotifierProvider<LocationPermissionNotifier, LocationPermission?>((ref) {
//   final permissionManagerPro = ref.watch(permissionManagerProvider);
//   return LocationPermissionNotifier(permissionManagerPro);
// });
//
// class LocationPermissionNotifier extends StateNotifier<LocationPermission?>
//     with WidgetsBindingObserver {
//   final PermissionManager _permissionManager;
//
//   LocationPermissionNotifier(this._permissionManager) : super(null){
//     WidgetsBinding.instance.addObserver(this);
//     _checkPermission();
//   }
//
//   Future<void> _checkPermission() async {
//     await _permissionManager.requestLocationPermission();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _checkPermission();
//       debugPrint("[DIDCHANGE]: 권한 재체크");
//     }else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
//       debugPrint("[BACKGROUND]: 권한 체크 중지");
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
// }
//
