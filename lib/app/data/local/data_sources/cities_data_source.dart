import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:weather_user/app/domain/entities/cities.dart';

final citiesDataSourceList = <CitiesModel>[];

Future<List<CitiesModel>> readAllCitiesJson() async {
  final String response =
      await rootBundle.loadString('assets/pre_loaded_cities.json');
  final data = await json.decode(response);
  return List<CitiesModel>.from(data.map((x) => CitiesModel.fromJson(x)));
}
