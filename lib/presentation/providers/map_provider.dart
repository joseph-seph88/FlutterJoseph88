import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:o2/domain/usecases/map_use_case.dart';
import '../../core/constants/app_constant.dart';
import '../../domain/entities/map_entity.dart';
import '../state/map_state.dart';

// 주소 검색값
final selectedAddressProvider = StateProvider<String>((ref) => '');

final mapParamProvider = StateProvider<Map<String, dynamic>>((ref) => {
  'iconPath': AppConstant.coffeePath,
  'position': const GeoPoint(37.499889, 126.920056),
});

final mapDataStreamProvider = StreamProvider
    .autoDispose<List<MapEntity>>((ref) {
  final mapUseCase = ref.watch(mapUseCaseProvider);
  final mapParam = ref.watch(mapParamProvider);
  String iconPath = mapParam['iconPath'];
  GeoPoint position = mapParam['position'];
  print("프로바이더 파라미터: $iconPath + ${position.longitude}");

  return mapUseCase.getMapDataWithIcon(iconPath, position).map((mapModels) {
    return mapModels.whereType<MapEntity>().toList();
  });
});


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
          mapDataList: [],
          iconDataList: [],
          predictionList: [],
        ));

  Future<void> addMarker(
      GeoPoint position, String iconPath, String address, String storeName) async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      await _mapUseCase.addMarker(position, address, iconPath, storeName);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<List<MapEntity>> searchStore(String inputText) async {
    state = state.copyWith(error: '');
    try{
      final searchStoreDataList = await _mapUseCase.searchStore(inputText);
      return searchStoreDataList;
    }catch(e){
      state = state.copyWith(error: e.toString());
    }
    return [];
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
