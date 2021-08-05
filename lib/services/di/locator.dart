import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_user/app/data/remote/data_sources/weather_remote_data_source.dart';
import 'package:weather_user/app/data/repositories/weather_repository_impl.dart';
import 'package:weather_user/app/domain/repositories/weather_repository.dart';
import 'package:weather_user/app/domain/use_cases/get_weather_by_city.dart';
import 'package:weather_user/app/domain/use_cases/get_weather_by_location.dart';
import 'package:weather_user/app/domain/use_cases/get_weather_forecast_by_city.dart';
import 'package:weather_user/app/domain/use_cases/get_weather_forecast_by_latlng.dart';
import 'package:weather_user/app/domain/use_cases/input_checker.dart';
import 'package:weather_user/app/presentation/manager/permission/app_permission_bloc.dart';
import 'package:weather_user/app/presentation/manager/weather/weather_bloc.dart';
import 'package:weather_user/services/network/network_info.dart';
import 'package:weather_user/utils/network/data_connection_checker.dart';

GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton<AppPermissionBloc>(() => AppPermissionBloc());
  sl.registerLazySingleton(() => Dio(BaseOptions(
        baseUrl: 'http://api.openweathermap.org/',
        connectTimeout: 5000,
        receiveTimeout: 100000,
        // 5s
        headers: {
          HttpHeaders.userAgentHeader: 'dio',
        },
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      )));
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => InputChecker());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(dataConnectionChecker: sl()));
  sl.registerLazySingleton(() => GetWeatherDataByCityName(sl()));
  sl.registerLazySingleton(() => GetWeatherDataBylocation(sl()));
  sl.registerLazySingleton(() => GetWeatherForecastDataByCityName(sl()));
  sl.registerLazySingleton(() => GetWeatherForecastDataByLocation(sl()));
  sl.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(() => WeatherRemoteDataImpl(
        client: sl(),
      ));
  sl.registerFactory(
    () => WeatherBloc(
      inputChecker: sl(),
      getWeatherDataByCityName: sl(),
      getWeatherDataBylocation: sl(),
      getWeatherForeCastDataByCityName: sl(),
      getWeatherForeCastDataBylocation: sl(),
    ),
  );
}
