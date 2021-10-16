import 'package:idee_flutter/models/geometry.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String vicinity;
  final String formatted_address;

  Place({this.geometry, this.name, this.vicinity, this.formatted_address});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      geometry: Geometry.fromJson(json['geometry']),
      name: json['formatted_address'],
      vicinity: json['vicinity'],
    );
  }
}
