import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:o2/domain/entities/map_entity.dart';
import '../../data/repositories/map_repository_impl.dart';
import '../repositories/map_repository.dart';

final mapUseCaseProvider = Provider((ref) {
  final mapRepository = ref.read(mapRepositoryProvider);
  return MapUseCaseImpl(mapRepository);
});

abstract class MapUseCase {
  Future<void> addMarker(
      GeoPoint position, String address, String iconPath, String storeName);

  Future<Placemark?> transAddressFromGeo(NLatLng clickPosition);

  Future<LatLng?> transPositionFromAddress(String address);

  Stream<List<MapEntity?>> getMapDataWithIcon(
      String iconPath, GeoPoint position);

  Future<List<MapEntity>> searchStore(String inputText);

  Future<List<MapEntity>> getStoreData();

  List<Map<String, dynamic>> get getIconDataList;

  Future<List<AutocompletePrediction>> getPredictions(String input);
}

class MapUseCaseImpl implements MapUseCase {
  final MapRepository _repository;

  MapUseCaseImpl(this._repository);

  @override
  Stream<List<MapEntity?>> getMapDataWithIcon(String iconPath, GeoPoint position) {
    try{
      return _repository.getMapDataWithIconStream(iconPath, position);
    }catch(e){
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
  Future<List<MapEntity>> getStoreData() async {
    try{
      final dataList = await _repository.getStoreData();
      return dataList;
    }catch(e){
      throw Exception("유스에러 $e");
    }
  }

  @override
  Future<void> addMarker(GeoPoint position, String address, String iconPath,
      String storeName) async {
    try {
      await _repository.addMarker(position, address, iconPath, storeName);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Placemark?> transAddressFromGeo(NLatLng clickPosition) async {
    try {
      return await _repository.transAddressFromGeo(clickPosition);
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
  List<Map<String, dynamic>> get getIconDataList {
    return _repository.getIconDataList;
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
}