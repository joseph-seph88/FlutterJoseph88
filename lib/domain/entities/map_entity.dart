import 'package:cloud_firestore/cloud_firestore.dart';

class MapEntity {
  final String? mapId;
  final GeoPoint position;
  final String address;
  final String storeName;
  final Map<String, dynamic> category;
  final double starRating;
  final int participant;

  MapEntity({
    this.mapId,
    required this.position,
    required this.address,
    required this.storeName,
    required this.category,
    required this.starRating,
    required this.participant,
  });
}
