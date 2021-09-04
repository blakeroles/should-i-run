import 'package:flutter/material.dart';
import 'package:should_i_run/constants.dart';
import 'package:should_i_run/components/custom_suffix_item.dart';
import 'package:should_i_run/size_config.dart';
import 'package:should_i_run/components/form_error.dart';
import 'package:should_i_run/components/default_button.dart';
import 'package:should_i_run/model/weather_response.dart';
import 'package:should_i_run/model/api_handler.dart';
import 'package:should_i_run/model/scorer.dart';
import 'package:http/http.dart' as http;

class LocationForm extends StatefulWidget {
  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final _formKey = GlobalKey<FormState>();
  String location;
  bool remember = false;
  final List<String> errors = [];
  final Map<int, String> airQualityMap = {
    1: 'Good',
    2: 'Moderate',
    3: 'Unhealthy for Sensitive People',
    4: 'Very Unhealthy',
    5: 'Hazardous'
  };
  Future<WeatherResponse> weatherResponse;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          buildLocationFormField(),
          Row(children: [
            Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                }),
            Text("Remember location"),
          ]),
          SizedBox(height: getProportionateScreenHeight(20)),
          FormError(errors: errors),
          DefaultButton(
              text: "Submit",
              press: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  WeatherApiHandler weatherApihandler =
                      new WeatherApiHandler(location);
                  weatherResponse = weatherApihandler.fetchWeatherData();

                  setState(() {});
                }
              }),
          SizedBox(height: getProportionateScreenHeight(20)),
          FutureBuilder<WeatherResponse>(
              future: weatherResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Scorer scorer = new Scorer(snapshot.data);
                  scorer.calcScore();
                  return Text(scorer.getScore().toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(28.0),
                        fontWeight: FontWeight.bold,
                      ));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Text('Score');
              }),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildTempFutureBuilder('Current Temperature: ', '\u2103'),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPrecipFutureBuilder('Current Precipitation: ', 'mm'),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildHumidityFutureBuilder('Current Humidity: ', '%'),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildAirQualityFutureBuilder('Current Air Quality: ', '')
        ]));
  }

  FutureBuilder<WeatherResponse> buildTempFutureBuilder(
      String factor, String unit) {
    return FutureBuilder<WeatherResponse>(
        future: weatherResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(factor + snapshot.data.tempResult.toString() + unit,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(16.0),
                  fontWeight: FontWeight.bold,
                ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Text('Score');
        });
  }

  FutureBuilder<WeatherResponse> buildPrecipFutureBuilder(
      String factor, String unit) {
    return FutureBuilder<WeatherResponse>(
        future: weatherResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(factor + snapshot.data.precipResult.toString() + unit,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(16.0),
                  fontWeight: FontWeight.bold,
                ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Text('Score');
        });
  }

  FutureBuilder<WeatherResponse> buildHumidityFutureBuilder(
      String factor, String unit) {
    return FutureBuilder<WeatherResponse>(
        future: weatherResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(factor + snapshot.data.humidityResult.toString() + unit,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(16.0),
                  fontWeight: FontWeight.bold,
                ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Text('Score');
        });
  }

  FutureBuilder<WeatherResponse> buildAirQualityFutureBuilder(
      String factor, String unit) {
    return FutureBuilder<WeatherResponse>(
        future: weatherResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
                factor + airQualityMap[snapshot.data.airQualityResult] + unit,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(16.0),
                  fontWeight: FontWeight.bold,
                ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Text('Score');
        });
  }

  TextFormField buildLocationFormField() {
    return TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (newValue) => location = newValue,
        onChanged: (value) {
          if (value.isNotEmpty && errors.contains(kLocationNullError)) {
            setState(() {
              errors.remove(kLocationNullError);
            });
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty && !errors.contains(kLocationNullError)) {
            setState(() {
              errors.add(kLocationNullError);
            });
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Location",
          hintText: "Enter your location",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(
            svgIcon: "assets/icons/Location point.svg",
          ),
        ));
  }
}
