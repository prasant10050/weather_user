import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';

class LocationDao {
  StoredLocation storedLocation;
  List<StoredLocation> listOfStoredLocation = [];
  LocationDao(
    this.storedLocation,
  );

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final String? selectedCityKey = prefs.getString(key);
    if (selectedCityKey == null || selectedCityKey.isEmpty) {
      return <StoredLocation>[];
    } else {
      return StoredLocation.decode(selectedCityKey);
    }
  }

  save(String key, StoredLocation value) async {
    final prefs = await SharedPreferences.getInstance();
    this.listOfStoredLocation.add(value);
    var entries = StoredLocation.encode(listOfStoredLocation.toList());
    prefs.setString(key, entries);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

class StoredLocation {
  final String? place;
  final LatLng? latLng;
  final bool isMyCurrentLocation;

  StoredLocation({this.place, this.latLng, this.isMyCurrentLocation = false});
  factory StoredLocation.fromJson(Map<String, dynamic> jsonData) {
    return StoredLocation(
      place: jsonData['place'],
      latLng: jsonData['latLng'] != null
          ? LatLng.fromJson(jsonData['latLng'])
          : jsonData['latLng'],
      isMyCurrentLocation: jsonData['isMyCurrentLocation'],
    );
  }

  static Map<String, dynamic> toMap(StoredLocation location) => {
        'place': location.place,
        'latLng': location.latLng,
        'isMyCurrentLocation': location.isMyCurrentLocation,
      };

  static String encode(List<StoredLocation> locations) => json.encode(
        locations
            .map<Map<String, dynamic>>(
                (location) => StoredLocation.toMap(location))
            .toList(),
      );

  static List<StoredLocation> decode(String locations) =>
      (json.decode(locations) as List<dynamic>)
          .map<StoredLocation>((item) => StoredLocation.fromJson(item))
          .toList();
}
