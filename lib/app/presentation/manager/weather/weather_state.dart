part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  @override
  List<Object> get props => [];
}

class InitialWeather extends WeatherState {
  @override
  List<Object> get props => [];
}

class LoadingWeather extends WeatherState {
  @override
  List<Object> get props => [];
}

class LoadedWeather extends WeatherState {
  final WeatherModel weather;
  LoadedWeather({required this.weather});
  @override
  List<Object> get props => [weather];
}

class ErrorWeather extends WeatherState {
  final String errorMessage;
  ErrorWeather({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class ChangePageIndexState extends WeatherState {
  final int currentIndex;

  ChangePageIndexState(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}

class LoadedWeatherForecastState extends WeatherState {
  final WeatherForeCastModel weatherForeCast;
  LoadedWeatherForecastState({required this.weatherForeCast});
  @override
  List<Object> get props => [weatherForeCast];
}
