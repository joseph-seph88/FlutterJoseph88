import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geocoding/geocoding.dart';
import '../../domain/entities/map_entity.dart';

class MapState {
  final bool isLoading;
  final String error;
  final Placemark? placeAddress;
  final LatLng? positionData;
  final List<MapEntity> mapDataList;
  final List<Map<String, dynamic>> iconDataList;
  final List<AutocompletePrediction> predictionList;

  MapState({
    required this.isLoading,
    required this.error,
    this.placeAddress,
    this.positionData,
    required this.mapDataList,
    required this.iconDataList,
    required this.predictionList,
  });

  MapState copyWith({
    bool? isLoading,
    String? error,
    Placemark? placeAddress,
    LatLng? positionData,
    List<MapEntity>? mapDataList,
    List<Map<String, dynamic>>? iconDataList,
    List<AutocompletePrediction>? predictionList,
  }) {
    return MapState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        placeAddress: placeAddress ?? this.placeAddress,
        positionData: positionData ?? this.positionData,
        mapDataList: mapDataList ?? this.mapDataList,
        iconDataList: iconDataList ?? this.iconDataList,
        predictionList: predictionList ?? this.predictionList);
  }
}
