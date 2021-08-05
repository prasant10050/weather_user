import 'dart:convert';

import 'package:equatable/equatable.dart';

LatLng latLngFromJson(String str) => LatLng.fromJson(json.decode(str));

String latLngToJson(LatLng data) => json.encode(data.toJson());

class LatLng extends Equatable {
  LatLng({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  factory LatLng.fromJson(Map<String, dynamic> json) => LatLng(
        latitude: json['latitude'] == null ? null : json['latitude'],
        longitude: json['longitude'] == null ? null : json['longitude'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [latitude, longitude];
}
