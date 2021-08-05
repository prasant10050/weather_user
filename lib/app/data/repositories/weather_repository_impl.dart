import 'package:dartz/dartz.dart';
import 'package:weather_user/app/data/remote/data_sources/weather_remote_data_source.dart';
import 'package:weather_user/app/data/remote/models/weather_forecast_model.dart';
import 'package:weather_user/app/data/remote/models/weather_model.dart';
import 'package:weather_user/app/domain/entities/error/exception.dart';
import 'package:weather_user/app/domain/entities/error/failure.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';
import 'package:weather_user/app/domain/repositories/weather_repository.dart';
import 'package:weather_user/services/network/network_info.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  WeatherRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, WeatherModel>> getWeatherByCityName(
      String cityName) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDataSource.getWeatherByCityName(cityName);
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WeatherModel>> getWeatherBylocation(
      LatLng latLng) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getWeatherBylocation(latLng);
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      } on LocationDisabledException {
        return Left(LocationDisabledFailure());
      } on LocationPermessionException {
        return Left(LocationPermessionFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WeatherForeCastModel>> getWeatherForecastByCityName(
      String cityName) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDataSource.getWeatherForecastByCityName(cityName);
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WeatherForeCastModel>> fetchWeatherForecastByLatLng(
      LatLng latLng) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDataSource.fetchWeatherForecastByLatLng(latLng);
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      } on LocationDisabledException {
        return Left(LocationDisabledFailure());
      } on LocationPermessionException {
        return Left(LocationPermessionFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }
}
