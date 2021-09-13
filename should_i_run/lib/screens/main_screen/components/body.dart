import 'package:flutter/material.dart';
import 'package:should_i_run/size_config.dart';
import 'package:should_i_run/screens/main_screen/components/location_form.dart';

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
              Text("Should I Run?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28.0),
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: getProportionateScreenHeight(10.0)),
              Text(
                "Enter your location to display score",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              LocationForm(),
            ]),
          ),
        ),
      ),
    );
  }
}
