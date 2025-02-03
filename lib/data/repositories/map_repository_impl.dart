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
  Future<void> addMarker(
      GeoPoint position, String address, String iconPath) async {
    final geoFirePoint = GeoFirePoint(position);
    final Map<String, dynamic> geo = {
      'geoHash': geoFirePoint.geohash,
      'geoPoint': geoFirePoint.geopoint,
    };

    try {
      final mapData = MapModel(geo: geo, address: address, iconPath: iconPath);
      final mapId = await _mapDataSource.addMarker(mapData);
      final mapDataWithId = mapData.copyWith(mapId: mapId);
      await _mapDataSource.updateMarker(mapId, mapDataWithId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MapEntity>> getMarkerList(GeoPoint position) async {
    try {
      final mapList = await _mapDataSource.getMarkersInRange(position);

      if (mapList.isNotEmpty) {
        return mapList.map((model) {
          return MapEntity(
            mapId: model.mapId,
            position: model.geo['geoPoint'],
            address: model.address,
            iconPath: model.iconPath,
          );
        }).toList();
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  @override
  Future<List<MapEntity>> getMapDataWithIcon(String iconPath) async {
    try {
      final mapList = await _mapDataSource.getMapDataWithIcon(iconPath);

      if (mapList.isNotEmpty) {
        return mapList.map((model) {
          return MapEntity(
            mapId: model.mapId,
            position: model.geo['geoPoint'],
            address: model.address,
            iconPath: model.iconPath,
          );
        }).toList();
      }
    } catch (e) {
      rethrow;
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
      final positionData = await _mapDataSource.transPositionFromAddress(address);
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
