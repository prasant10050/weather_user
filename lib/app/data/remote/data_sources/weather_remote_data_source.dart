import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:weather_user/app/data/remote/models/weather_forecast_model.dart';
import 'package:weather_user/app/data/remote/models/weather_model.dart';
import 'package:weather_user/app/domain/entities/error/exception.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';
import 'package:weather_user/values/values.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeatherBylocation(LatLng latlng);
  Future<WeatherModel> getWeatherByCityName(String cityName);
  Future<WeatherForeCastModel> getWeatherForecastByCityName(String cityName);
  Future<WeatherForeCastModel> fetchWeatherForecastByLatLng(LatLng latLng);
}

const String apiKey = '2b3d51173c5fdec394b5cff634db9f4b';
const String weatherUrl = 'http://api.openweathermap.org/data/2.5/weather?';
const String forecastUrl = 'http://api.openweathermap.org/data/2.5/forecast?';
const String units = '&units=metric';

class WeatherRemoteDataImpl implements WeatherRemoteDataSource {
  Dio client;

  WeatherRemoteDataImpl({
    required this.client,
  });

  @override
  Future<WeatherModel> getWeatherByCityName(String cityName) async {
    String link = weatherUrl + 'q=$cityName' + '&appid=$apiKey' + units;
    final uri = Uri.http(
      base_url,
      '$base_url_path$weather_path',
      {'q': '$cityName', 'appid': '$apiKey'},
    );
    final response = await client.get(link);
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<WeatherModel> getWeatherBylocation(LatLng latlng) async {
    if (!await Location.instance.serviceEnabled()) {
      throw LocationDisabledException();
    }
    double latitude = latlng.latitude;
    double longitude = latlng.longitude;
    String link = weatherUrl +
        'lat=$latitude&' +
        'lon=$longitude' +
        '&appid=$apiKey' +
        units;
    final response = await client.get(link);
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<WeatherForeCastModel> getWeatherForecastByCityName(
      String cityName) async {
    String link = forecastUrl + 'q=$cityName' + '&appid=$apiKey' + units;
    final response = await client.get(link);
    if (response.statusCode == 200) {
      return WeatherForeCastModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<WeatherForeCastModel> fetchWeatherForecastByLatLng(
      LatLng latLng) async {
    if (!await Location.instance.serviceEnabled()) {
      throw LocationDisabledException();
    }
    double latitude = latLng.latitude;
    double longitude = latLng.longitude;
    String link = forecastUrl +
        'lat=$latitude&' +
        'lon=$longitude' +
        '&appid=$apiKey' +
        units;
    final response = await client.get(link);
    if (response.statusCode == 200) {
      return WeatherForeCastModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
