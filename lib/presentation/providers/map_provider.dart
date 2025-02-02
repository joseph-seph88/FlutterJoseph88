import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:o2/core/utils/permission_manager.dart';
import 'package:o2/domain/entities/map_entity.dart';
import 'package:o2/domain/usecases/map_use_case.dart';
import 'package:permission_handler/permission_handler.dart';

// State
class MapState {
  final bool isLoading;
  final String error;
  final Placemark? placeAddress;
  final String defaultIconPath;
  final List<MapEntity> mapDataList;

  MapState({
    required this.isLoading,
    required this.error,
    this.placeAddress,
    required this.defaultIconPath,
    required this.mapDataList,
  });

  MapState copyWith({
    bool? isLoading,
    String? error,
    Placemark? placeAddress,
    String? defaultIconPath,
    List<MapEntity>? mapDataList,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      placeAddress: placeAddress ?? this.placeAddress,
      defaultIconPath: defaultIconPath ?? this.defaultIconPath,
      mapDataList: mapDataList ?? this.mapDataList,
    );
  }
}

// Map Provider & Notifier
final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  final mapUseCase = ref.read(mapUseCaseProvider);
  return MapNotifier(mapUseCase);
});

class MapNotifier extends StateNotifier<MapState> {
  final MapUseCaseImpl _mapUseCase;

  MapNotifier(this._mapUseCase)
      : super(MapState(
            isLoading: false,
            error: '',
            placeAddress: null,
            defaultIconPath: 'assets/icons/location.png',
            mapDataList: []));

  Future<void> addMarker(
      GeoPoint position, String iconPath, NLatLng clickPosition) async {
    state = state.copyWith(isLoading: true);
    try {
      final placeAddress = await transAddressFromGeo(clickPosition);
      final address = placeAddress?.street ?? '';
      await _mapUseCase.addMarker(position, address, iconPath);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getMarkers(GeoPoint position) async {
    state = state.copyWith(isLoading: false);
    try {
      final mapDataList = await _mapUseCase.getMarkers(position);
      state = state.copyWith(isLoading: true, mapDataList: mapDataList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getMapDataWithIcon(String iconPath) async {
    state = state.copyWith(isLoading: false);
    try {
      final mapDataList = await _mapUseCase.getMapDataWithIcon(iconPath);
      state = state.copyWith(isLoading: true, mapDataList: mapDataList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Placemark?> transAddressFromGeo(NLatLng clickPosition) async {
    try {
      final placeAddress = await _mapUseCase.transAddressFromGeo(clickPosition);
      state = state.copyWith(placeAddress: placeAddress);
      return placeAddress;
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
    return null;
  }
}

// Permission Provider
final locationPermissionProvider =
    StateNotifierProvider<LocationPermissionNotifier, PermissionStatus?>((ref) {
  final permissionManagerPro = ref.watch(permissionManagerProvider);
  return LocationPermissionNotifier(permissionManagerPro);
});

// Permission
class LocationPermissionNotifier extends StateNotifier<PermissionStatus?> {
  final PermissionManager _permissionManager;

  LocationPermissionNotifier(this._permissionManager) : super(null);

  Future<void> requestPermission() async {
    await _permissionManager.requestLocationPermission();
    state = await Permission.location.status;
  }
}



