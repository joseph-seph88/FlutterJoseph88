import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/map_entity.dart';

class MapState {
  final bool isLoading;
  final String error;
  final String transAddress;
  final List<MapEntity> mapDataList;
  final List<Map<String, dynamic>> staticCategory;
  final List<MapEntity> searchStoreDataList;
  final Set<NMarker> markersSet;
  final List<int> betweenDistance;
  final AsyncValue<String> asyncTransAddress;
  final AsyncValue<NLatLng> asyncTargetPosition;
  final AsyncValue<List<AutocompletePrediction>> asyncPredictionList;

  MapState({
    required this.isLoading,
    required this.error,
    required this.transAddress,
    required this.mapDataList,
    required this.staticCategory,
    required this.searchStoreDataList,
    required this.markersSet,
    required this.betweenDistance,
    required this.asyncTransAddress,
    required this.asyncTargetPosition,
    required this.asyncPredictionList,
  });

  MapState copyWith({
    bool? isLoading,
    String? error,
    String? transAddress,
    List<MapEntity>? mapDataList,
    List<Map<String, dynamic>>? staticCategory,
    List<MapEntity>? searchStoreDataList,
    Set<NMarker>? markersSet,
    List<int>? betweenDistance,
    AsyncValue<String>? asyncTransAddress,
    AsyncValue<NLatLng>? asyncTargetPosition,
    AsyncValue<List<AutocompletePrediction>>? asyncPredictionList,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      transAddress: transAddress ?? this.transAddress,
      mapDataList: mapDataList ?? this.mapDataList,
      staticCategory: staticCategory ?? this.staticCategory,
      searchStoreDataList: searchStoreDataList ?? this.searchStoreDataList,
      markersSet: markersSet ?? this.markersSet,
      betweenDistance: betweenDistance ?? this.betweenDistance,
      asyncTransAddress: asyncTransAddress ?? this.asyncTransAddress,
      asyncTargetPosition: asyncTargetPosition ?? this.asyncTargetPosition,
      asyncPredictionList: asyncPredictionList ?? this.asyncPredictionList,
    );
  }
}
