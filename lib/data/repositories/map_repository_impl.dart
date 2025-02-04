import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:o2/data/datasources/map_data_source.dart';
import '../../domain/entities/map_entity.dart';
import '../../domain/repositories/map_repository.dart';
import '../models/map_model.dart';

final mapRepositoryProvider = Provider<MapRepositoryImpl>((ref) {
  final mapDataSource = ref.read(mapDataSourceProvider);
  return MapRepositoryImpl(mapDataSource);
});

class MapRepositoryImpl implements MapRepository {
  final MapDataSource _mapDataSource;

  MapRepositoryImpl(this._mapDataSource);

  @override
  Future<void> addMarker(GeoPoint position, String address, String iconPath,
      String storeName) async {
    final geoFirePoint = GeoFirePoint(position);
    final Map<String, dynamic> geo = {
      'geohash': geoFirePoint.geohash,
      'geopoint': geoFirePoint.geopoint,
    };

    try {
      final mapData = MapModel(
          geo: geo, address: address, iconPath: iconPath, storeName: storeName);
      final mapId = await _mapDataSource.addMarker(mapData);
      final mapDataWithId = mapData.copyWith(mapId: mapId);
      await _mapDataSource.updateMarker(mapId, mapDataWithId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<MapEntity?>> getMapDataWithIconStream(
      String iconPath, GeoPoint position) {
    try {
      return _mapDataSource.getMapDataWithIconStream(iconPath, position).map((mapModels) {
        return mapModels.map((model) {
          return MapEntity(
            mapId: model?.mapId,
            position: model?.geo['geopoint'],
            address: model!.address,
            iconPath: model.iconPath,
            storeName: model.storeName,
          );
        }).toList();
      });
    } catch (e) {
      throw Exception('맵레포에러: $e');
    }
  }

  @override
  Future<List<MapEntity>> searchStore(String inputText) async {
    try {
      final mapList = await _mapDataSource.searchStore(inputText);

      if (mapList.isNotEmpty) {
        return mapList.map((model) {
          return MapEntity(
            mapId: model.mapId,
            position: model.geo['geopoint'],
            address: model.address,
            iconPath: model.iconPath,
            storeName: model.storeName,
          );
        }).toList();
      }
    } catch (e) {
      throw Exception("레포구현에러: $e");
    }
    return [];
  }

  @override
  Future<Placemark?> transAddressFromGeo(NLatLng clickPosition) async {
    try {
      final mapAddress = _mapDataSource.transAddressFromGeo(
          clickPosition.latitude, clickPosition.longitude);
      return mapAddress;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LatLng?> transPositionFromAddress(String address) async {
    try {
      final positionData =
          await _mapDataSource.transPositionFromAddress(address);
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
    return _mapDataSource.selectIconData;
  }

  @override
  Future<List<AutocompletePrediction>> getPredictions(String input) async {
    try {
      final result = await _mapDataSource.getPredictions(input);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
