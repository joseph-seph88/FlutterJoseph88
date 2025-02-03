
class MapModel {
  final String? mapId;
  final Map<String, dynamic> geo;
  final String address;
  final String iconPath;

  MapModel({
    this.mapId,
    required this.geo,
    required this.address,
    required this.iconPath,
  });

  MapModel copyWith({
    String? mapId,
    Map<String, dynamic>? geo,
    String? address,
    String? iconPath,
  }) {
    return MapModel(
        mapId: mapId ?? this.mapId,
        geo: geo ?? this.geo,
        address: address ?? this.address,
        iconPath: iconPath ?? this.iconPath);
  }

  Map<String, dynamic> toMap() {
    return {
      'mapId': mapId,
      'geo': geo,
      'address': address,
      'iconPath': iconPath,
    };
  }

  factory MapModel.fromMap(Map<String, dynamic> mapData) {
    return MapModel(
        mapId: mapData['mapId'],
        geo: mapData['geo'],
        address: mapData['address'],
        iconPath: mapData['iconPath']);
  }
}
