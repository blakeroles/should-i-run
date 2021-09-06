import 'package:flutter/widgets.dart';
import 'package:should_i_run/screens/main_screen/main_screen.dart';
import 'package:should_i_run/screens/forecast_screen/forecast_screen.dart';

final Map<String, WidgetBuilder> routes = {
  MainScreen.routeName: (context) => MainScreen(),
  ForecastScreen.routeName: (context) => ForecastScreen(),
};
