import 'dart:convert';

List<CitiesModel> citiesModelFromJson(String str) => List<CitiesModel>.from(
    json.decode(str).map((x) => CitiesModel.fromJson(x)));

String citiesModelToJson(List<CitiesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CitiesModel {
  CitiesModel({
    this.city = '',
    this.lat = '',
    this.lng = '',
    this.country = '',
    this.iso2 = '',
    this.adminName = '',
    this.capital = '',
    this.population = '',
    this.populationProper = '',
  });

  final String city;
  final String lat;
  final String lng;
  final String country;
  final String iso2;
  final String adminName;
  final String capital;
  final String population;
  final String populationProper;

  factory CitiesModel.fromJson(Map<String, dynamic> json) => CitiesModel(
        city: json['city'] == null ? null : json['city'],
        lat: json['lat'] == null ? null : json['lat'],
        lng: json['lng'] == null ? null : json['lng'],
        country: json['country'] == null ? null : json['country'],
        iso2: json['iso2'] == null ? null : json['iso2'],
        adminName: json['admin_name'] == null ? null : json['admin_name'],
        capital: json['capital'] == null ? null : json['capital'],
        population: json['population'] == null ? null : json['population'],
        populationProper: json['population_proper'] == null
            ? null
            : json['population_proper'],
      );

  Map<String, dynamic> toJson() => {
        'city': city == null ? null : city,
        'lat': lat == null ? null : lat,
        'lng': lng == null ? null : lng,
        'country': country == null ? null : country,
        'iso2': iso2 == null ? null : iso2,
        'admin_name': adminName == null ? null : adminName,
        'capital': capital == null ? null : capital,
        'population': population == null ? null : population,
        'population_proper': populationProper == null ? null : populationProper,
      };
}
