import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<void> addMarker(GeoPoint position, String address, String iconPath);

  Future<List<MapEntity?>> getMarkers(GeoPoint position);

  Future<Placemark?> transAddressFromGeo(NLatLng clickPosition);

  Future<List<MapEntity?>> getMapDataWithIcon(String iconPath);
}

class MapUseCaseImpl implements MapUseCase {
  final MapRepository _repository;

  MapUseCaseImpl(this._repository);

  @override
  Future<List<MapEntity>> getMarkers(GeoPoint position) async {
    try {
      final mapDataList = await _repository.getMarkerList(position);
      return mapDataList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MapEntity>> getMapDataWithIcon(String iconPath) async {
    try {
      final mapDataList = await _repository.getMapDataWithIcon(iconPath);
      return mapDataList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addMarker(
      GeoPoint position, String address, String iconPath) async {
    try {
      await _repository.addMarker(position, address, iconPath);
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
}
