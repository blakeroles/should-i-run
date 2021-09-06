import 'package:flutter/material.dart';
import 'package:should_i_run/screens/forecast_screen/components/body.dart';
import 'package:should_i_run/size_config.dart';

class ForecastScreen extends StatelessWidget {
  static String routeName = "/forecast_screen";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
