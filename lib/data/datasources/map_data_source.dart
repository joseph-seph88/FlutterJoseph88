import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:o2/data/models/map_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fireStoreProvider = Provider((ref) => FirebaseFirestore.instance);
final mapDataSourceProvider = Provider((ref) {
  final fireStore = ref.read(fireStoreProvider);
  return MapDataSource(fireStore);
});


class MapDataSource {
  final FirebaseFirestore _fireStore;

  MapDataSource(this._fireStore);

  Future<Placemark?> transAddressFromGeo(double latitude,
      double longitude) async {
    try {
      List<Placemark> placeMarks =
      await placemarkFromCoordinates(latitude, longitude);
      return placeMarks.isNotEmpty ? placeMarks.first : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addMarker(MapModel mapData) async {
    try {
      final mapDoc = await _fireStore.collection('maps').add(mapData.toMap());
      return mapDoc.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MapModel>> getMapDataWithIcon(String iconPath) async {
    try {
      final mapData = await _fireStore.collection('maps').where(
          'iconPath', isEqualTo: iconPath).get();
      return mapData.docs.map((doc) => MapModel.fromMap(doc.data())).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MapModel>> getMarkersInRange(GeoPoint position) async {
    try {
      final mapData = await _fireStore.collection('maps').where(
          'geo', isLessThan: 2).get();
      return mapData.docs.map((doc) => MapModel.fromMap(doc.data())).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMarker(String mapId, MapModel mapData) async {
    try {
      await _fireStore.collection('maps').doc(mapId).update(mapData.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeMarker(String mapId) async {
    try {
      await _fireStore.collection('maps').doc(mapId).delete();
    } catch (e) {
      rethrow;
    }
  }

}
