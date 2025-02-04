import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:o2/data/models/map_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constant.dart';

final fireStoreProvider = Provider((ref) => FirebaseFirestore.instance);
final placesSdkProvider = Provider<FlutterGooglePlacesSdk>((ref) {
  return FlutterGooglePlacesSdk('AIzaSyCWjE7YvMlqTO-Tyb4mSez58w0T1CSwrMk',
      locale: const Locale('ko', 'KR'));
});

final mapDataSourceProvider = Provider((ref) {
  final fireStore = ref.read(fireStoreProvider);
  final placeSdk = ref.read(placesSdkProvider);
  return MapDataSource(fireStore, placeSdk);
});

class MapDataSource {
  final FirebaseFirestore _fireStore;
  final FlutterGooglePlacesSdk _places;

  MapDataSource(this._fireStore, this._places);

  Future<Placemark?> transAddressFromGeo(
      double latitude, double longitude) async {
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(latitude, longitude);
      return placeMarks.isNotEmpty ? placeMarks.first : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<LatLng?> transPositionFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(
            lat: locations.first.latitude, lng: locations.first.longitude);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<List<AutocompletePrediction>> getPredictions(String input) async {
    try {
      final result =
          await _places.findAutocompletePredictions(input, countries: ['KR']);
      return result.predictions;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addMarker(MapModel mapData) async {
    try {
      final mapDoc = await _fireStore.collection('maps').add(mapData.toMap());
      print("추가성공");
      return mapDoc.id;
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

  Stream<List<MapModel?>> getMapDataWithIconStream(String iconPath, GeoPoint position) {
    final CollectionReference<Map<String, dynamic>> collectionReference = _fireStore.collection('maps');
    final GeoFirePoint center = GeoFirePoint(GeoPoint(position.latitude, position.longitude));

    GeoPoint geopointFrom(Map<String, dynamic> data) {
      final geo = data['geo'] as Map<String, dynamic>;
      final geoPoint = geo['geopoint'] as GeoPoint;
      return geoPoint;
    }

    return GeoCollectionReference<Map<String, dynamic>>(collectionReference)
        .subscribeWithin(
        center: center,
        radiusInKm: 3 * 0.05,
        field: 'geo',
        geopointFrom: geopointFrom
    )
        .map((docs) {
      final filteredDocs = docs.where((doc) {
        final iconPathDoc = doc['iconPath'];
        return iconPathDoc == iconPath;
      }).toList();

      final mapModels = filteredDocs.map((doc) {
        final data = doc.data();
        return data != null ? MapModel.fromMap(data) : null;
      }).where((mapModel) => mapModel != null).toList();

      return mapModels;
    });
  }


  Future<List<MapModel>> searchStore(String queryText) async {
    try {
      var searchData = await FirebaseFirestore.instance
          .collection('maps')
          .where('storeName', isGreaterThanOrEqualTo: queryText)
          .where('storeName', isLessThan: '$queryText\uf8ff')
          .get();
      print("검색디피 : ${searchData.size}");
      return searchData.docs.map((doc) => MapModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception("DB서치에러");
    }
  }


  final List<Map<String, dynamic>> _selectIconData = [
    {
      "icon": AppConstant.coffeePath,
      "label": AppConstant.coffee,
      "color": AppConstant.brownColor
    },
    {
      "icon": AppConstant.fishPath,
      "label": AppConstant.fish,
      "color": AppConstant.orangeColor
    },
    {
      "icon": AppConstant.foodPath,
      "label": AppConstant.food,
      "color": AppConstant.indigoColor
    },
    {
      "icon": AppConstant.icecreamPath,
      "label": AppConstant.icecream,
      "color": AppConstant.lightGreenColor
    },
    {
      "icon": AppConstant.trashPath,
      "label": AppConstant.trash,
      "color": AppConstant.deepPurpleColor
    },
  ];

  List<Map<String, dynamic>> get selectIconData => _selectIconData;
}
