import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_user/app/data/remote/models/weather_forecast_model.dart';
import 'package:weather_user/app/data/remote/models/weather_model.dart';
import 'package:weather_user/app/presentation/widgets/weatherData.dart';
import 'package:weather_user/utils/weather_status.dart';
import 'package:weather_user/utils/weather_utils.dart';

import 'seven_days_forecast.dart';

class SingleWeather extends StatelessWidget {
  final int index;
  final WeatherModel listElement;
  final WeatherForeCastModel weatherForeCastModel;

  SingleWeather(this.index, this.listElement, this.weatherForeCastModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Text(
                      listElement.name,
                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      //DateFormat('EEE, MMM dd, yy  hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(listElement.dt * 1000)),
                      DateFormat('EEE, MMM dd, yy hh:mm a').format(
                          MapString.getTime(
                              listElement.dt, listElement.timezone)),
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${listElement.main!.temp.toStringAsFixed(0)}°C',
                      style: GoogleFonts.lato(
                        fontSize: 85,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          listElement.main != null
                              ? weatherStatus[listElement.weather![0].main]
                                  ['icon']
                              : 'assets/icons/sand-clock.svg',
                          width: 34,
                          height: 34,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${listElement.weather![0].description}',
                          style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeatherData(
                      title: 'Wind',
                      value: listElement.wind!.speed,
                      sign: 'km/h',
                      barColor: Colors.redAccent,
                      barWidthFactor: listElement.wind!.speed != null
                          ? listElement.wind!.speed / 25 <= 1
                              ? listElement.wind!.speed / 25
                              : 1
                          : 0,
                    ),
                    WeatherData(
                      title: 'Pressure',
                      value: listElement.main!.pressure,
                      sign: 'hPa',
                      barColor: Colors.blueAccent,
                      barWidthFactor: listElement.main!.pressure == null
                          ? 0
                          : abs(listElement.main!.pressure) / 10000,
                    ),
                    WeatherData(
                      title: 'Humidity',
                      value: listElement.main!.humidity,
                      sign: '%',
                      barColor: Colors.greenAccent,
                      barWidthFactor: listElement.main!.humidity == null
                          ? 0
                          : abs(listElement.main!.humidity) / 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Visibility(
            child: SevenDayForecast(
              dWeather: weatherForeCastModel.list!.toList(),
              wData: listElement,
            ),
            replacement: Offstage(),
            visible: weatherForeCastModel != null &&
                weatherForeCastModel.list != null &&
                weatherForeCastModel.list!.isNotEmpty,
          ),
        ],
      ),
    );
  }
}
