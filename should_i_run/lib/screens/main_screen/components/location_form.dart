import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:should_i_run/constants.dart';
import 'package:should_i_run/components/custom_suffix_item.dart';
import 'package:should_i_run/model/forecast_scorer.dart';
import 'package:should_i_run/size_config.dart';
import 'package:should_i_run/components/form_error.dart';
import 'package:should_i_run/components/default_button.dart';
import 'package:should_i_run/model/weather_response.dart';
import 'package:should_i_run/model/api_handler.dart';
import 'package:should_i_run/components/line_chart.dart';

class LocationForm extends StatefulWidget {
  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final _formKey = GlobalKey<FormState>();
  final locationFormFieldController = TextEditingController();
  final countryFormFieldController = TextEditingController();
  String location;
  String country;
  String initialLocation;
  String initialCountry;
  bool rememberLocation = false;
  bool calculateForecast = false;
  final List<String> errors = [];
  final Map<int, String> airQualityMap = {
    1: 'Good',
    2: 'Moderate',
    3: 'Unhealthy for Sensitive People',
    4: 'Unhealthy',
    5: 'Very Unhealthy',
    6: 'Hazardous'
  };
  Future<WeatherResponse> weatherResponse;

  @override
  void initState() {
    super.initState();
    loadInitialLocation();
  }

  void loadInitialLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      locationFormFieldController.text =
          (prefs.getString('initialLocation') ?? '');
      countryFormFieldController.text =
          (prefs.getString('initialCountry') ?? '');
    });
  }

  void saveInitialLocation() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('initialLocation', location);
    prefs.setString('initialCountry', country);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          buildLocationFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildCountryFormField(),
          Row(children: [
            Checkbox(
                value: rememberLocation,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    rememberLocation = value;
                  });
                }),
            Text("Remember location"),
            Spacer(),
            Checkbox(
                value: calculateForecast,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    calculateForecast = value;
                  });
                }),
            Text("Show Forecast"),
          ]),
          SizedBox(height: getProportionateScreenHeight(15)),
          FormError(errors: errors),
          DefaultButton(
              text: "Calculate Score",
              press: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  processApi(location + "," + country);
                }
              }),
          SizedBox(height: getProportionateScreenHeight(10)),
          FutureBuilder<WeatherResponse>(
              future: weatherResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ForecastScorer scorer = new ForecastScorer(
                      snapshot.data.tempResult,
                      snapshot.data.precipResult,
                      snapshot.data.airQualityResult,
                      snapshot.data.humidityResult);
                  scorer.calcScore();
                  return Row(
                    children: [
                      Spacer(),
                      Text(scorer.getScore().toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(92.0),
                            fontWeight: FontWeight.bold,
                          )),
                      Text('/100',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(20.0),
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Text('');
              }),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildLocationFutureBuilder(),
          SizedBox(height: getProportionateScreenHeight(20)),
          Visibility(
            visible: !calculateForecast,
            child: buildLocalTimeFutureBuilder('Current Time: ', ''),
          ),
          Visibility(
            visible: !calculateForecast,
            child: SizedBox(height: getProportionateScreenHeight(20)),
          ),
          Visibility(
            visible: !calculateForecast,
            child: buildTempFutureBuilder('Current Temperature: ', '\u2103'),
          ),
          Visibility(
            visible: !calculateForecast,
            child: SizedBox(height: getProportionateScreenHeight(20)),
          ),
          Visibility(
            visible: !calculateForecast,
            child: buildPrecipFutureBuilder('Current Precipitation: ', 'mm'),
          ),
          Visibility(
            visible: !calculateForecast,
            child: SizedBox(height: getProportionateScreenHeight(20)),
          ),
          Visibility(
            visible: !calculateForecast,
            child: buildHumidityFutureBuilder('Current Humidity: ', '%'),
          ),
          Visibility(
            visible: !calculateForecast,
            child: SizedBox(height: getProportionateScreenHeight(20)),
          ),
          Visibility(
              visible: !calculateForecast,
              child: buildAirQualityFutureBuilder('Current Air Quality: ', '')),
          Visibility(
            visible: calculateForecast,
            child: buildScoreGraphFutureBuilder(),
          ),
        ]));
  }

  FutureBuilder<WeatherResponse> buildLocationFutureBuilder() {
    return FutureBuilder<WeatherResponse>(
        future: weatherResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
                'Location is ' +
                    snapshot.data.name +
                    ', ' +
                    snapshot.data.region +
                    ', ' +
                    snapshot.data.country,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(14.0),
                  fontWeight: FontWeight.bold,
                ));
          } else if (snapshot.hasError) {
            return Text('');
          }
          return Text('');
        });
  }

  FutureBuilder<WeatherResponse> buildLocalTimeFutureBuilder(
      String factor, String unit) {
    return FutureBuilder<WeatherResponse>(
        future: weatherResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(factor + snapshot.data.localTime.split(' ')[1] + unit,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(12.0),
                ));
          } else if (snapshot.hasError) {
            return Text('');
          }
          return Text('');
        });
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
                  fontSize: getProportionateScreenWidth(12.0),
                ));
          } else {
            return CircularProgressIndicator();
          }
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
                  fontSize: getProportionateScreenWidth(12.0),
                ));
          } else if (snapshot.hasError) {
            return Text('');
          }
          return Text('');
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
                  fontSize: getProportionateScreenWidth(12.0),
                ));
          } else if (snapshot.hasError) {
            return Text('');
          }
          return Text('');
        });
  }

  FutureBuilder<WeatherResponse> buildScoreGraphFutureBuilder() {
    return FutureBuilder<WeatherResponse>(
        future: weatherResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ForecastChart(weatherResponse);
          } else if (snapshot.hasError) {
            return Text('');
          }
          return Text('');
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
                  fontSize: getProportionateScreenWidth(12.0),
                ));
          } else if (snapshot.hasError) {
            return Text('');
          }
          return Text('');
        });
  }

  TextFormField buildLocationFormField() {
    return TextFormField(
        controller: locationFormFieldController,
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
          labelText: "Suburb",
          hintText: "Enter your suburb",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(
            svgIcon: "assets/icons/Location point.svg",
            iconSize: 18,
          ),
        ));
  }

  TextFormField buildCountryFormField() {
    return TextFormField(
        controller: countryFormFieldController,
        keyboardType: TextInputType.text,
        onSaved: (newValue) => country = newValue,
        onChanged: (value) {
          if (value.isNotEmpty && errors.contains(kCountryNullError)) {
            setState(() {
              errors.remove(kCountryNullError);
            });
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty && !errors.contains(kCountryNullError)) {
            setState(() {
              errors.add(kCountryNullError);
            });
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Country",
          hintText: "Enter your country",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(
            svgIcon: "assets/icons/Location point.svg",
            iconSize: 18,
          ),
        ));
  }

  void processApi(String loc) {
    WeatherApiHandler weatherApihandler = new WeatherApiHandler(loc);
    weatherResponse = weatherApihandler.fetchWeatherData();
    if (rememberLocation) {
      saveInitialLocation();
    }
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {});
  }
}
