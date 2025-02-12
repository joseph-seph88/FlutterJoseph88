import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:o2/core/utils/color_trans_util.dart';
import 'package:o2/data/datasources/map_data_source.dart';
import '../../domain/entities/map_entity.dart';
import '../../domain/repositories/map_repository.dart';
import '../models/map_model.dart';
import 'package:flutter/material.dart';


class MapRepositoryImpl implements MapRepository {
  final MapDataSource _mapDataSource;

  MapRepositoryImpl(this._mapDataSource);

  @override
  Future<void> addMarker(
      GeoPoint position,
      String address,
      Map<String, dynamic> category,
      String storeName,
      double starRating,
      int participant) async {
    final geoFirePoint = GeoFirePoint(position);
    final Map<String, dynamic> geo = {
      'geohash': geoFirePoint.geohash,
      'geopoint': geoFirePoint.geopoint,
    };

    try {
      final mapData = MapModel(
        geo: geo,
        address: address,
        storeName: storeName,
        category: category,
        starRating: starRating,
        participant: participant,
      );
      final mapId = await _mapDataSource.addMarker(mapData);
      final mapDataWithId = mapData.copyWith(mapId: mapId);
      await _mapDataSource.updateMarker(mapId, mapDataWithId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<MapEntity?>> getMapDataWithIconStream(
      String category, GeoPoint position) {
    try {
      return _mapDataSource
          .getMapDataWithIconStream(category, position)
          .map((mapModels) {
        return mapModels.map((model) {
          final String colorString = model?.category['iconColor'];
          final Color iconColor = ColorTransUtil.transStringToColor(colorString);

          return MapEntity(
              mapId: model?.mapId,
              position: model?.geo['geopoint'],
              address: model!.address,
              storeName: model.storeName,
              category: {
                ...model.category,
                'iconColor':iconColor,
              },
              starRating: model.starRating,
              participant: model.participant);
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
          final String colorString = model.category['iconColor'];
          final Color iconColor = ColorTransUtil.transStringToColor(colorString);

          return MapEntity(
              mapId: model.mapId,
              position: model.geo['geopoint'],
              address: model.address,
              storeName: model.storeName,
              category: {
                ...model.category,
                'iconColor': iconColor,
              },
              starRating: model.starRating,
              participant: model.participant);
        }).toList();
      }
    } catch (e) {
      throw Exception("레포구현에러: $e");
    }
    return [];
  }

  @override
  Future<List<MapEntity>> getAllMapData() async {
    try {
      final mapList = await _mapDataSource.getAllMapData();

      if (mapList.isNotEmpty) {
        return mapList.map((model) {
          final String colorString = model.category['iconColor'];
          final Color iconColor =
              ColorTransUtil.transStringToColor(colorString);

          return MapEntity(
              mapId: model.mapId,
              position: model.geo['geopoint'],
              address: model.address,
              storeName: model.storeName,
              category: {
                ...model.category,
                'iconColor': iconColor,
              },
              starRating: model.starRating,
              participant: model.participant);
        }).toList();
      }
    } catch (e) {
      throw Exception("레포구현에러: $e");
    }
    return [];
  }

  @override
  Future<Placemark?> transPositionToAddress(NLatLng currentPosition) async {
    try {
      final mapAddress = _mapDataSource.transPositionToAddress(
          currentPosition.latitude, currentPosition.longitude);
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
  List<Map<String, dynamic>> get getStaticCategoryData {
    return _mapDataSource.getStaticCategoryData;
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

  @override
  Future<MapEntity> updateStarRating(
      String mapId, int participant, double starRating) async {
    try {
      final updateMapData =
          await _mapDataSource.updateStarRating(mapId, participant, starRating);
      final String colorString = updateMapData.category['iconColor'];
      final Color iconColor = ColorTransUtil.transStringToColor(colorString);

      return MapEntity(
          mapId: updateMapData.mapId,
          position: updateMapData.geo['geopoint'],
          address: updateMapData.address,
          storeName: updateMapData.storeName,
          category: {
            ...updateMapData.category,
            'iconColor':iconColor,
          },
          starRating: updateMapData.starRating,
          participant: updateMapData.participant);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MapEntity> getMapData(String mapId) async {
    try {
      final mapData = await _mapDataSource.getMapData(mapId);
      final String colorString = mapData.category['iconColor'];
      final Color iconColor = ColorTransUtil.transStringToColor(colorString);

      return MapEntity(
          mapId: mapData.mapId,
          position: mapData.geo['geopoint'],
          address: mapData.address,
          storeName: mapData.storeName,
          category: {
            ...mapData.category,
            'iconColor': iconColor,
          },
          starRating: mapData.starRating,
          participant: mapData.participant);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LatLng?> getLatLng(String placeId) async {
    return _mapDataSource.getLatLng(placeId);
  }
}
