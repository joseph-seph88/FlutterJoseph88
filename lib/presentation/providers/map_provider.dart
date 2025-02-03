import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:o2/domain/usecases/map_use_case.dart';
import '../state/map_state.dart';

// 주소 검색값
final selectedAddressProvider = StateProvider<String>((ref) => '');

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
          mapDataList: [],
          iconDataList: [],
          predictionList: [],
        ));

  Future<void> addMarker(
      GeoPoint position, String iconPath, String address) async {
    state = state.copyWith(isLoading: true);
    try {
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
      print("프로바이더: ${mapDataList.length}");
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

  Future<LatLng?> transPositionFromAddress(String address) async {
    try {
      final positionData = await _mapUseCase.transPositionFromAddress(address);
      if (positionData != null) {
        state = state.copyWith(positionData: positionData);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
    return null;
  }

  void get getIconDataList {
    final iconDataList = _mapUseCase.getIconDataList;
    state = state.copyWith(iconDataList: iconDataList);
  }

  Future<void> getPredictionList(String input) async {
    try {
      final result = await _mapUseCase.getPredictions(input);
      state = state.copyWith(predictionList: result);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
