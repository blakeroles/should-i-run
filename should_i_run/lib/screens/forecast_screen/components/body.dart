import 'package:flutter/material.dart';
import 'package:should_i_run/size_config.dart';
import 'package:should_i_run/components/tappable_custom_suffix_item.dart';
import 'package:should_i_run/screens/main_screen/main_screen.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Row(
                children: [
                  TappableCustomSuffixIcon(
                    svgIcon: "assets/icons/arrow_left.svg",
                    screenRoute: MainScreen.routeName,
                  ),
                  SizedBox(width: getProportionateScreenWidth(25.0)),
                  Text("Forecast Screen",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(28.0),
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
