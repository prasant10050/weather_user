part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetWeatherByLocation extends WeatherEvent {
  final LatLng latLng;

  GetWeatherByLocation(this.latLng);

  @override
  List<Object> get props => [];
}

class GetWeatherByCityName extends WeatherEvent {
  final String cityName;
  GetWeatherByCityName({required this.cityName});

  @override
  List<Object> get props => [cityName];
}

class ChangePageIndex extends WeatherEvent {
  final int currentIndex;

  ChangePageIndex(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}

class GetWeatherForeCastByLocation extends WeatherEvent {
  final LatLng latLng;

  GetWeatherForeCastByLocation(this.latLng);

  @override
  List<Object> get props => [];
}

class GetWeatherForeCastByCityName extends WeatherEvent {
  final String cityName;

  GetWeatherForeCastByCityName(this.cityName);

  @override
  List<Object> get props => [];
}
