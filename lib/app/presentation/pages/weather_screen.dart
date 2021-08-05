import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_user/app/data/remote/models/weather_forecast_model.dart';
import 'package:weather_user/app/data/remote/models/weather_model.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';
import 'package:weather_user/app/presentation/manager/weather/weather_bloc.dart';
import 'package:weather_user/app/presentation/widgets/buildin_transform.dart';
import 'package:weather_user/app/presentation/widgets/error_widget.dart';
import 'package:weather_user/app/presentation/widgets/single_weather.dart';
import 'package:weather_user/app/presentation/widgets/slider_dot.dart';
import 'package:weather_user/services/dao/location_dao.dart';
import 'package:weather_user/utils/weather_status.dart';

import 'city_selection.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  List<WeatherModel> listElement = [];
  List<WeatherModel> localListElement = [];
  late WeatherForeCastModel weatherForeCastModel;
  List<WeatherForeCastModel> listOfWeatherForecastModel = [];
  List<WeatherForeCastModel> localListOfWeatherForecastModel = [];
  int _currentPage = 0;
  late WeatherBloc weatherBloc;
  LocationDao locationDao = LocationDao();

  _onPageChanged(int? index) {
    weatherBloc.add(ChangePageIndex(index!));
  }

  @override
  void initState() {
    weatherForeCastModel = WeatherForeCastModel();
    weatherBloc = BlocProvider.of<WeatherBloc>(context);
    initPlatformState();
    super.initState();
  }

  initPlatformState() async {
    //Kuala Lumpur
    weatherBloc.add(GetWeatherByCityName(cityName: 'Kuala Lumpur'));
    await Future.delayed(Duration(milliseconds: 1000));
    //George Town
    weatherBloc.add(GetWeatherByCityName(cityName: 'George Town'));
    await Future.delayed(Duration(milliseconds: 1000));
    //Johor Bahru
    weatherBloc.add(GetWeatherByCityName(cityName: 'Johor Bahru'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constrations) {
          return Container(
            height: constrations.biggest.height,
            width: constrations.biggest.width,
            child: BlocBuilder<WeatherBloc, WeatherState>(
              bloc: weatherBloc,
              builder: (context, state) {
                if (state is InitialWeather) {
                  listElement = [];
                  localListElement = [];
                  return Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()),
                  );
                } else if (state is ErrorWeather) {
                  return ErrorsWidget(message: state.errorMessage);
                } else if (state is LoadedWeather) {
                  listElement.add(state.weather);
                  listElement = listElement.toSet().toList();
                  listElement.asMap().forEach((i, e) {
                    if (!localListElement.contains(e.id)) {
                      localListElement.add(e);
                    }
                  });
                  localListElement = localListElement.toSet().toList();
                } else if (state is LoadingWeather) {
                  return Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()),
                  );
                } else if (state is ChangePageIndexState) {
                  _currentPage = state.currentIndex;
                } else if (state is LoadedWeatherForecastState) {
                  //weatherForeCastModel = state.weatherForeCast;
                  listOfWeatherForecastModel.add(state.weatherForeCast);
                  listOfWeatherForecastModel =
                      listOfWeatherForecastModel.toSet().toList();
                  listOfWeatherForecastModel.asMap().forEach((i, e) {
                    if (!localListOfWeatherForecastModel.contains(e)) {
                      localListOfWeatherForecastModel.add(e);
                    }
                  });
                  localListOfWeatherForecastModel =
                      localListOfWeatherForecastModel.toSet().toList();
                }
                // Screen
                return (localListElement.length == 0 ||
                        localListOfWeatherForecastModel.length == 0)
                    ? Center(
                        child: Container(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()),
                      )
                    : Stack(
                        children: [
                          Image.asset(
                            weatherStatus[localListElement[_currentPage]
                                .weather![0]
                                .main]['img'],
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.black38),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 140, left: 15),
                            child: Row(
                              children: [
                                for (int i = 0;
                                    (i < localListElement.length &&
                                        localListOfWeatherForecastModel.length >
                                            0);
                                    i++)
                                  if (i == _currentPage)
                                    SliderDot(true)
                                  else
                                    SliderDot(false)
                              ],
                            ),
                          ),
                          TransformerPageView(
                            scrollDirection: Axis.horizontal,
                            transformer: ScaleAndFadeTransformer(),
                            viewportFraction: 0.8,
                            onPageChanged: _onPageChanged,
                            itemCount: localListElement.toSet().toList().length,
                            itemBuilder: (ctx, i) => SingleWeather(
                              i,
                              localListElement[i],
                              localListOfWeatherForecastModel[i],
                            ),
                          ),
                          Positioned(
                            top: 36.0,
                            left: 8.0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              iconSize: 32,
                              color: Colors.white,
                              onPressed: () => Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CitySelectionScreen(
                                    backgroundImage:
                                        localListElement[_currentPage]
                                            .weather![0]
                                            .main,
                                  ),
                                ),
                              )
                                  .then((value) {
                                if (value is String) {
                                  BlocProvider.of<WeatherBloc>(context).add(
                                      GetWeatherByCityName(cityName: value[0]));
                                } else {
                                  BlocProvider.of<WeatherBloc>(context).add(
                                      GetWeatherByLocation(LatLng(
                                          latitude: value[1].latitude,
                                          longitude: value[1].longitude)));
                                }
                              }),
                            ),
                          ),
                        ],
                      );
              },
            ),
          );
        },
      ),
    );
  }
}
