import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();

    if (Platform.isAndroid) {
      await _handleAndroidPermission(status);
    } else if (Platform.isIOS) {
      await _handleIOSPermission(status);
    }
  }

  Future<void> _handleAndroidPermission(PermissionStatus status) async {
    if (status.isGranted) {
      debugPrint("ANDROID: 위치 권한 허용됨");
    } else if (status.isDenied) {
      debugPrint("ANDROID: 위치 권한 일시적 거부됨");
      await Permission.location.request();
    } else if (status.isPermanentlyDenied) {
      debugPrint("ANDROID: 위치 권한 영구적 거부됨");
      openAppSettings();
      _checkLocationPermission();
    }
  }

  Future<void> _handleIOSPermission(PermissionStatus status) async {
    if (status.isGranted) {
      debugPrint("IOS: 위치 권한 허용됨");
    } else if (status.isDenied) {
      debugPrint("IOS: 위치 권한 일시적 거부됨");
      await Permission.location.request();
    } else if (status.isPermanentlyDenied) {
      debugPrint("IOS: 위치 권한 영구적 거부됨");
      await openAppSettings();
      _checkLocationPermission();
    }
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      debugPrint("위치 권한 허용됨");
    } else {
      debugPrint("위치 권한 거부됨");
    }
  }
}
