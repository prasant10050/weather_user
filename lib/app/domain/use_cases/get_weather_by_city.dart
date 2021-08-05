import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_user/app/data/remote/models/weather_model.dart';
import 'package:weather_user/app/domain/entities/error/failure.dart';
import 'package:weather_user/app/domain/repositories/weather_repository.dart';
import 'package:weather_user/app/domain/use_cases/usecase.dart';

class GetWeatherDataByCityName extends Usecase<WeatherModel, CityParams> {
  final WeatherRepository weatherRepository;

  GetWeatherDataByCityName(this.weatherRepository);

  @override
  Future<Either<Failure, WeatherModel>> call(CityParams params) async {
    return await weatherRepository.getWeatherByCityName(params.cityName);
  }
}

class CityParams extends Equatable {
  CityParams({required this.cityName});
  final String cityName;

  @override
  List<Object> get props => [cityName];
}
