import 'package:dartz/dartz.dart';
import 'package:weather_user/app/data/remote/models/weather_forecast_model.dart';
import 'package:weather_user/app/domain/entities/error/failure.dart';
import 'package:weather_user/app/domain/repositories/weather_repository.dart';
import 'package:weather_user/app/domain/use_cases/usecase.dart';

import 'get_weather_by_city.dart';

class GetWeatherForecastDataByCityName
    extends Usecase<WeatherForeCastModel, CityParams> {
  final WeatherRepository weatherRepository;

  GetWeatherForecastDataByCityName(this.weatherRepository);

  @override
  Future<Either<Failure, WeatherForeCastModel>> call(CityParams params) async {
    return await weatherRepository
        .getWeatherForecastByCityName(params.cityName);
  }
}
