import 'package:cloud_firestore/cloud_firestore.dart';

class MapEntity {
  final String? mapId;
  final GeoPoint position;
  final String address;
  final String iconPath;

  MapEntity({
    this.mapId,
    required this.position,
    required this.address,
    required this.iconPath,
  });
}