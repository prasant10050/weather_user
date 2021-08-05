import 'package:dartz/dartz.dart';
import 'package:weather_user/app/data/remote/models/weather_forecast_model.dart';
import 'package:weather_user/app/data/remote/models/weather_model.dart';
import 'package:weather_user/app/domain/entities/error/failure.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherModel>> getWeatherBylocation(LatLng latLng);
  Future<Either<Failure, WeatherModel>> getWeatherByCityName(String cityName);
  Future<Either<Failure, WeatherForeCastModel>> getWeatherForecastByCityName(
      String cityName);
  Future<Either<Failure, WeatherForeCastModel>> fetchWeatherForecastByLatLng(
      LatLng latLng);
}
