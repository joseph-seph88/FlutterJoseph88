import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
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
        return LatLng(lat: locations.first.latitude, lng: locations.first.longitude);
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

  Future<List<MapModel>> getMapDataWithIcon(String iconPath) async {
    try {
      final mapData = await _fireStore
          .collection('maps')
          .where('iconPath', isEqualTo: iconPath)
          .get();
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


  Future<List<MapModel>> getMarkersInRange(GeoPoint position) async {
    const GeoPoint centerPoint = GeoPoint(37.499889, 126.920056);
    const GeoFirePoint center = GeoFirePoint(centerPoint);
    const double radiusInKm = 2;
    const field = 'geo';
    NCameraPosition cameraPosition;

    //
    // final _geoQueryCondition = BehaviorSubject<_GeoQueryCondition>.seeded(
    //   _GeoQueryCondition(
    //     radiusInKm: radiusInKm,
    //     cameraPosition: cameraPosition,
    //   ),
    // );
    //
    // NCameraPosition get _cameraPosition => _geoQueryCondition.value.cameraPosition;

    final CollectionReference<Map<String, dynamic>> collectionReference =
        _fireStore.collection('maps');

    GeoPoint geopointFrom(Map<String, dynamic> data) =>
        (data['geo'] as Map<String, dynamic>)['geoPoint'] as GeoPoint;

    // late final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> _stream =
    // _geoQueryCondition.switchMap(
    //       (geoQueryCondition) =>
    //       GeoCollectionReference(collectionReference).subscribeWithin(
    //         center: GeoFirePoint(
    //           GeoPoint(
    //             _cameraPosition.target.latitude,
    //             _cameraPosition.target.longitude,
    //           ),
    //         ),
    //         radiusInKm: geoQueryCondition.radiusInKm,
    //         field: 'geo',
    //         geopointFrom: (data) =>
    //         (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
    //         strictMode: true,
    //       ),
    // );

    final snapshotList =
        await GeoCollectionReference<Map<String, dynamic>>(collectionReference)
            .fetchWithinWithDistance(
      center: center,
      radiusInKm: radiusInKm,
      field: field,
      geopointFrom: geopointFrom,
          strictMode: false,
          geohashField: 'geo.geoHash',
          queryBuilder: (query) => query,
    );

    print("데이터 크기1: ${snapshotList.length}");
    final mapList = snapshotList.map((doc) {
      print("문서 데이터: ${doc.documentSnapshot.data()}");
      return MapModel.fromMap(doc.documentSnapshot.data()!);
    }).toList();
    print("데이터 크기2: ${mapList.length}");
    return mapList;
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

class _GeoQueryCondition {
  _GeoQueryCondition({
    required this.radiusInKm,
    required this.cameraPosition,
  });

  final double radiusInKm;
  final NCameraPosition cameraPosition;
}