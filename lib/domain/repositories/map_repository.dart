import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import '../entities/map_entity.dart';

abstract class MapRepository {
  Future<Placemark?> transAddressFromGeo(NLatLng clickPosition);

  Future<LatLng?> transPositionFromAddress(String address);

  Future<void> addMarker(GeoPoint position, String address, String iconPath, String storeName);

  Stream<List<MapEntity?>> getMapDataWithIconStream(String iconPath, GeoPoint position);

  Future<List<MapEntity>> searchStore(String inputText);

  List<Map<String, dynamic>> get getIconDataList;

  Future<List<AutocompletePrediction>> getPredictions(String input);
}