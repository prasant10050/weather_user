import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_user/app/data/remote/models/weather_forecast_model.dart';
import 'package:weather_user/app/data/remote/models/weather_model.dart';
import 'package:weather_user/app/domain/entities/error/failure.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';
import 'package:weather_user/app/domain/use_cases/get_weather_by_city.dart';
import 'package:weather_user/app/domain/use_cases/get_weather_by_location.dart';
import 'package:weather_user/app/domain/use_cases/get_weather_forecast_by_city.dart';
import 'package:weather_user/app/domain/use_cases/get_weather_forecast_by_latlng.dart';
import 'package:weather_user/app/domain/use_cases/input_checker.dart';
import 'package:weather_user/values/values.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherDataByCityName getWeatherDataByCityName;
  final GetWeatherDataBylocation getWeatherDataBylocation;
  final GetWeatherForecastDataByCityName getWeatherForeCastDataByCityName;
  final GetWeatherForecastDataByLocation getWeatherForeCastDataBylocation;
  final InputChecker inputChecker;

  WeatherBloc({
    required this.getWeatherDataByCityName,
    required this.getWeatherDataBylocation,
    required this.inputChecker,
    required this.getWeatherForeCastDataByCityName,
    required this.getWeatherForeCastDataBylocation,
  }) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetWeatherByCityName) {
      final checkerResult = inputChecker.checkOfStringInput(event.cityName);
      yield* checkerResult.fold(
        (inpurtFailure) async* {
          yield ErrorWeather(errorMessage: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (str) async* {
          //yield LoadingWeather();
          final failurOrWeather = await getWeatherDataByCityName(
              CityParams(cityName: event.cityName));
          yield* failurOrWeather.fold((failure) async* {
            String errorMessage = _mapFailureToMessage(failure);
            yield ErrorWeather(errorMessage: errorMessage);
          }, (weather) async* {
            yield LoadedWeather(weather: weather);
            //await Future.delayed(Duration(milliseconds: 100));
            add(GetWeatherForeCastByCityName(event.cityName));
          });
        },
      );
    } else if (event is GetWeatherByLocation) {
      //yield LoadingWeather();
      final failurOrWeather = await getWeatherDataBylocation(event.latLng);
      yield* failurOrWeather.fold((failure) async* {
        String errorMessage = _mapFailureToMessage(failure);
        yield ErrorWeather(errorMessage: errorMessage);
      }, (weather) async* {
        yield LoadedWeather(weather: weather);
        //await Future.delayed(Duration(milliseconds: 100));
        add(GetWeatherForeCastByLocation(event.latLng));
      });
    } else if (event is ChangePageIndex) {
      yield ChangePageIndexState(event.currentIndex);
    } else if (event is GetWeatherForeCastByLocation) {
      //yield LoadingWeather();
      final failurOrWeather =
          await getWeatherForeCastDataBylocation(event.latLng);
      yield* failurOrWeather.fold((failure) async* {
        String errorMessage = _mapFailureToMessage(failure);
        yield ErrorWeather(errorMessage: errorMessage);
      }, (weather) async* {
        yield LoadedWeatherForecastState(weatherForeCast: weather);
      });
    } else if (event is GetWeatherForeCastByCityName) {
      //yield LoadingWeather();
      final failurOrWeather = await getWeatherForeCastDataByCityName(
          CityParams(cityName: event.cityName));
      yield* failurOrWeather.fold((failure) async* {
        String errorMessage = _mapFailureToMessage(failure);
        yield ErrorWeather(errorMessage: errorMessage);
      }, (weather) async* {
        yield LoadedWeatherForecastState(weatherForeCast: weather);
      });
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return SERVER_FAILURE_MESSAGE;
    } else if (failure is CacheFailure) {
      return CACHE_FAILURE_MESSAGE;
    } else if (failure is LocationDisabledFailure) {
      return LOCATION_DISABLED_FAILURE_MESSAGE;
    } else if (failure is LocationPermessionFailure) {
      return LOCATION_PERMESSION_FAILURE_MESSAGE;
    } else if (failure is InvalidInputFailure) {
      return INVALID_INPUT_FAILURE_MESSAGE;
    } else {
      return "Un Expected Error";
    }
  }
}
