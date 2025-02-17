import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import '../entities/map_entity.dart';

abstract class MapRepository {
  Future<Placemark?> transPositionToAddress(NLatLng currentPosition);

  Future<LatLng?> transPositionFromAddress(String address);

  Future<void> addMarker(
      GeoPoint position,
      String address,
      Map<String, dynamic> category,
      String storeName,
      double starRating,
      int participant);

  Stream<List<MapEntity?>> getMapDataWithIconStream(
      String category, GeoPoint position);

  Future<List<MapEntity>> searchStore(String inputText);

  Future<List<MapEntity>> getAllMapData();

  List<Map<String, dynamic>> get getStaticCategoryData;

  Future<List<AutocompletePrediction>> getPredictions(String input);

  Future<MapEntity> updateStarRating(String mapId, int participant,
      double starRating);

  Future<MapEntity> getMapData(String mapId);

  Future<LatLng?> getLatLng(String placeId);
}
