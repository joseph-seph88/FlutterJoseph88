import '../../domain/entities/map_entity.dart';
import 'package:flutter/material.dart';

class MapModel {
  final String? mapId;
  final Map<String, dynamic> geo;
  final String address;
  final String storeName;
  final Map<String, dynamic> category;
  final double starRating;
  final int participant;

  MapModel({
    this.mapId,
    required this.geo,
    required this.address,
    required this.storeName,
    required this.category,
    required this.starRating,
    required this.participant,
  });

  MapModel copyWith({
    String? mapId,
    Map<String, dynamic>? geo,
    String? address,
    String? storeName,
    Map<String, dynamic>? category,
    double? starRating,
    int? participant,
  }) {
    return MapModel(
      mapId: mapId ?? this.mapId,
      geo: geo ?? this.geo,
      address: address ?? this.address,
      storeName: storeName ?? this.storeName,
      category: category ?? this.category,
      starRating: starRating ?? this.starRating,
      participant: participant ?? this.participant,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mapId': mapId,
      'geo': geo,
      'address': address,
      'storeName': storeName,
      'category': category,
      'starRating': starRating,
      'participant': participant,
    };
  }

  factory MapModel.fromMap(Map<String, dynamic> mapData) {
    return MapModel(
      mapId: mapData['mapId'],
      geo: mapData['geo'],
      address: mapData['address'],
      storeName: mapData['storeName'],
      category: mapData['category'],
      starRating: mapData['starRating'],
      participant: mapData['participant'],
    );
  }

  MapEntity toEntity(Color iconColor) {
    return MapEntity(
      mapId: mapId,
      position: geo['geopoint'],
      address: address,
      storeName: storeName,
      category: {
        ...category,
        'iconColor': iconColor,
      },
      starRating: starRating,
      participant: participant,
    );
  }
}
