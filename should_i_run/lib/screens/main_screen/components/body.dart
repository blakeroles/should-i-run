import 'package:flutter/material.dart';
import 'package:should_i_run/constants.dart';
import 'package:should_i_run/size_config.dart';

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
              Text("Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28.0),
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                "Sign in with your email and password \nor continue with social media",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              SizedBox(height: getProportionateScreenHeight(20.0)),
            ]),
          ),
        ),
      ),
    );
  }
}
