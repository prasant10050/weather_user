import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_user/app/data/remote/models/weather_forecast_model.dart';
import 'package:weather_user/app/data/remote/models/weather_model.dart';
import 'package:weather_user/utils/weather_status.dart';

class SevenDayForecast extends StatelessWidget {
  final WeatherModel wData;
  final List<ListElement> dWeather;

  SevenDayForecast({required this.wData, this.dWeather = const []});

  Widget dailyWidget(ListElement weather, BuildContext context) {
    final dt_time = DateFormat('E, ha')
        .format(DateTime.fromMillisecondsSinceEpoch(weather.dt * 1000));
    //final dayOfWeek = DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(weather.dt * 1000));
    final dayOfWeek = DateFormat('E, ha').format(weather.dtTxt!);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5.5,
        vertical: 4.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              dayOfWeek,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text(
              '${weather.main!.temp.toStringAsFixed(0)}°C',
              style: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            //child: MapString.mapStringToIcon('${weather.weather![0].main}', context, 35),
          ),
          SvgPicture.asset(
            weather.weather![0].main != null
                ? weatherStatus[weather.weather![0].main]['icon']
                : 'assets/icons/sand-clock.svg',
            width: 34,
            height: 34,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 8.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                Row(
                  children: dWeather
                      .map((item) => dailyWidget(item, context))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
