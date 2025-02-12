import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:o2/domain/entities/map_entity.dart';
import '../repositories/map_repository.dart';

abstract class MapUseCase {
  Future<void> addMarker(
      GeoPoint position,
      String address,
      Map<String, dynamic> category,
      String storeName,
      double starRating,
      int participant);

  Future<Placemark?> transPositionToAddress(NLatLng currentPosition);

  Future<LatLng?> transPositionFromAddress(String address);

  Stream<List<MapEntity?>> getMapDataWithIcon(
      String category, GeoPoint position);

  Future<List<MapEntity>> searchStore(String inputText);

  Future<List<MapEntity>> getAllMapData();

  List<Map<String, dynamic>> get getStaticCategoryData;

  Future<List<AutocompletePrediction>> getPredictions(String input);

  Future<MapEntity> updateStarRating(
      String mapId, int participant, double starRating);

  Future<MapEntity> getMapData(String mapId);

  Future<LatLng?> getLatLng(String placeId);
}

class MapUseCaseImpl implements MapUseCase {
  final MapRepository _repository;

  MapUseCaseImpl(this._repository);

  @override
  Stream<List<MapEntity?>> getMapDataWithIcon(
      String category, GeoPoint position) {
    try {
      return _repository.getMapDataWithIconStream(category, position);
    } catch (e) {
      throw Exception("맵유스에러 $e");
    }
  }

  @override
  Future<List<MapEntity>> searchStore(String inputText) async {
    try {
      final searchDataList = await _repository.searchStore(inputText);
      return searchDataList;
    } catch (e) {
      throw Exception("유스에러 $e");
    }
  }

  @override
  Future<List<MapEntity>> getAllMapData() async {
    try {
      final dataList = await _repository.getAllMapData();
      return dataList;
    } catch (e) {
      throw Exception("유스에러 $e");
    }
  }

  @override
  Future<void> addMarker(
      GeoPoint position,
      String address,
      Map<String, dynamic> category,
      String storeName,
      double starRating,
      int participant) async {
    try {
      await _repository.addMarker(
          position, address, category, storeName, starRating, participant);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Placemark?> transPositionToAddress(NLatLng currentPosition) async {
    try {
      return await _repository.transPositionToAddress(currentPosition);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LatLng?> transPositionFromAddress(String address) async {
    try {
      final positionData = await _repository.transPositionFromAddress(address);
      if (positionData != null) {
        return positionData;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  List<Map<String, dynamic>> get getStaticCategoryData {
    return _repository.getStaticCategoryData;
  }

  @override
  Future<List<AutocompletePrediction>> getPredictions(String input) async {
    try {
      final result = await _repository.getPredictions(input);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MapEntity> updateStarRating(
      String mapId, int participant, double starRating) async {
    try {
      final result =
          await _repository.updateStarRating(mapId, participant, starRating);
      return result;
    } catch (e) {
      throw Exception("유스에러 $e");
    }
  }

  @override
  Future<MapEntity> getMapData(String mapId) async{
    try {
      final mapData = await _repository.getMapData(mapId);
      return mapData;
    } catch (e) {
      throw Exception("유스에러 $e");
    }
  }

  @override
  Future<LatLng?> getLatLng(String placeId) {
    return _repository.getLatLng(placeId);
  }
}
