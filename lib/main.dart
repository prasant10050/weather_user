import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_user/app/presentation/pages/weather_screen.dart';
import 'package:weather_user/values/values.dart';

import 'app/presentation/manager/permission/app_permission_bloc.dart';
import 'app/presentation/manager/weather/weather_bloc.dart';
import 'services/di/locator.dart';
import 'utils/theme/theme_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeStore().kLightTheme;
    final darkTheme = ThemeStore().kDarkTheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppPermissionBloc>(create: (_) => sl<AppPermissionBloc>()),
        BlocProvider<WeatherBloc>(create: (_) => sl<WeatherBloc>()),
      ],
      child: Listener(
        onPointerDown: (_) {
          var currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: app_name,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: WeatherScreen(),
        ),
      ),
    );
  }
}
