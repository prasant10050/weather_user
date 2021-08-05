import 'package:dartz/dartz.dart';
import 'package:weather_user/app/data/remote/models/weather_forecast_model.dart';
import 'package:weather_user/app/domain/entities/error/failure.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';
import 'package:weather_user/app/domain/repositories/weather_repository.dart';
import 'package:weather_user/app/domain/use_cases/usecase.dart';

class GetWeatherForecastDataByLocation
    extends Usecase<WeatherForeCastModel, LatLng> {
  final WeatherRepository weatherRepository;

  GetWeatherForecastDataByLocation(this.weatherRepository);

  @override
  Future<Either<Failure, WeatherForeCastModel>> call(LatLng params) async {
    return await weatherRepository.fetchWeatherForecastByLatLng(params);
  }
}
