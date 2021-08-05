import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_user/values/values.dart';

class ThemeStore {
  ThemeData get kLightTheme => _lightTheme();

  ThemeData get kDarkTheme => _darkTheme();

  ThemeData _lightTheme() {
    final base = ThemeData.light();
    final Color primaryColor = kPrimaryColor;
    final Color accentColor = kAccentColor;
    return base.copyWith(
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      accentTextTheme: _textTheme(base.accentTextTheme, accentColor),
      accentColor: accentColor,
      primaryColor: primaryColor,
      primaryColorDark: kPrimaryColorLight,
      primaryColorLight: kPrimaryColorLight,
      backgroundColor: kBackgroundColor,
      textTheme: _textTheme(base.textTheme, kTextThemeColor),
      primaryTextTheme: _textTheme(base.textTheme, kPrimaryTextThemeColor),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData _darkTheme() {
    final base = ThemeData.dark();
    final Color primaryColor = kPrimaryColor;
    final Color accentColor = kAccentColor;
    return base.copyWith(
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      accentTextTheme: _textTheme(base.accentTextTheme, accentColor),
      accentColor: accentColor,
      primaryColor: primaryColor,
      primaryColorDark: kPrimaryColorDark,
      primaryColorLight: kPrimaryColorLight,
      backgroundColor: kDarkBackgroundColor,
      textTheme: _textTheme(base.textTheme, kPrimaryTextThemeColor),
      primaryTextTheme: _textTheme(base.textTheme, kPrimaryTextThemeColor),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        brightness: Brightness.dark,
      ),
    );
  }

  TextTheme _textTheme(TextTheme base, Color color) {
    return base.copyWith(
      headline1: GoogleFonts.poppins(
        fontSize: 96,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: color,
      ),
      headline2: GoogleFonts.poppins(
        fontSize: 60,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        color: color,
      ),
      headline3: GoogleFonts.poppins(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      headline4: GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: color,
      ),
      headline5: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      headline6: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: color,
      ),
      subtitle1: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: color,
      ),
      subtitle2: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: color,
      ),
      bodyText1: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: color,
      ),
      bodyText2: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: color,
      ),
      button: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
        color: color,
      ),
      caption: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: color,
      ),
      overline: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        color: color,
      ),
    );
  }
}
