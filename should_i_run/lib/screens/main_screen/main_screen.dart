import 'package:flutter/material.dart';
import 'package:should_i_run/screens/main_screen/components/body.dart';
import 'package:should_i_run/size_config.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
