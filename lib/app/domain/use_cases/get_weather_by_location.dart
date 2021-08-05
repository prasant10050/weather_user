import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_user/app/data/remote/models/weather_model.dart';
import 'package:weather_user/app/domain/entities/error/failure.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';
import 'package:weather_user/app/domain/repositories/weather_repository.dart';
import 'package:weather_user/app/domain/use_cases/usecase.dart';

class GetWeatherDataBylocation extends Usecase<WeatherModel, LatLng> {
  final WeatherRepository weatherRepository;
  GetWeatherDataBylocation(this.weatherRepository);

  @override
  Future<Either<Failure, WeatherModel>> call(LatLng params) async {
    print("Location ${params.latitude}, ${params.longitude}");
    return await weatherRepository.getWeatherBylocation(params);
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
