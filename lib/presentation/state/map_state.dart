import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../domain/entities/map_entity.dart';

class MapState {
  final bool isLoading;
  final String error;
  final String transAddress;
  final LatLng positionData;
  final List<MapEntity> mapDataList;
  final List<Map<String, dynamic>> staticCategory;
  final List<AutocompletePrediction> predictionList;
  final List<MapEntity> searchStoreDataList;
  final Set<NMarker> markersSet;

  MapState({
    required this.isLoading,
    required this.error,
    required this.transAddress,
    required this.positionData,
    required this.mapDataList,
    required this.staticCategory,
    required this.predictionList,
    required this.searchStoreDataList,
    required this.markersSet,
  });

  MapState copyWith({
    bool? isLoading,
    String? error,
    String? transAddress,
    LatLng? positionData,
    List<MapEntity>? mapDataList,
    List<Map<String, dynamic>>? staticCategory,
    List<AutocompletePrediction>? predictionList,
    List<MapEntity>? searchStoreDataList,
    Set<NMarker>? markersSet,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      transAddress: transAddress ?? this.transAddress,
      positionData: positionData ?? this.positionData,
      mapDataList: mapDataList ?? this.mapDataList,
      staticCategory: staticCategory ?? this.staticCategory,
      predictionList: predictionList ?? this.predictionList,
      searchStoreDataList: searchStoreDataList ?? this.searchStoreDataList,
      markersSet: markersSet ?? this.markersSet,
    );
  }
}
