import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionManagerProvider = Provider((ref) => PermissionManager());

class PermissionManager with WidgetsBindingObserver {
  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (Platform.isAndroid) {
      await _handleAndroidPermission(status);
    } else if (Platform.isIOS) {
      await _handleIOSPermission(status);
    }
  }

  Future<void> _handleAndroidPermission(PermissionStatus status) async {
    try {
      if (status.isGranted) {
        debugPrint("ANDROID: 위치 권한 허용됨");
      } else if (status.isDenied) {
        var newStatus = await Permission.location.request();
        if (newStatus.isGranted) {
          debugPrint("ANDROID: 위치 권한 허용됨");
        } else {
          debugPrint("ANDROID: 위치 권한 거부됨");
          await openAppSettingsM();
        }
      } else if (status.isPermanentlyDenied) {
        debugPrint("ANDROID: 위치 권한 영구적 거부됨");
        await openAppSettingsM();
      } else {
        debugPrint("ANDROID: 아무튼 위치 권한 거부됨");
      }
    } catch (e) {
      debugPrint("권한 요청 중 오류 발생: $e");
    }
  }

  Future<void> _handleIOSPermission(PermissionStatus status) async {
    if (status.isGranted) {
      debugPrint("IOS: 위치 권한 허용됨");
    } else if (status.isDenied) {
      var newStatus =
          await Permission.locationWhenInUse.request(); // 포그라운드 권한 요청
      if (newStatus.isGranted) {
        debugPrint("IOS: 위치 권한 허용됨");
      } else {
        debugPrint("IOS: 위치 권한 거부됨");
        var newStatusForBackground = await Permission.locationAlways.request();
        if (newStatusForBackground.isGranted) {
          debugPrint("IOS: 백그라운드 위치 권한 허용됨");
        } else {
          debugPrint("IOS: 위치 권한 여전히 거부됨");
          await openAppSettingsM();
        }
      }
    } else if (status.isPermanentlyDenied) {
      debugPrint("IOS: 위치 권한 영구적 거부됨");
      await openAppSettingsM();
    } else {
      debugPrint("IOS: 아무튼 위치 권한 거부됨");
    }
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      debugPrint("recheck: 위치 권한 허용됨");
    } else if (status.isDenied) {
      debugPrint("recheck: 위치 권한 거부됨");
      await openAppSettingsM();
    } else if (status.isPermanentlyDenied) {
      debugPrint("recheck: 위치 권한 영구적 거부됨");
      await openAppSettingsM();
    }
  }

  Future<void> openAppSettingsM() async {
    await openAppSettings();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLocationPermission();
    }
  }

  void initializeLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  void disposeLifecycleObserver() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
