import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:should_i_run/constants.dart';
import 'package:should_i_run/components/custom_suffix_item.dart';
import 'package:should_i_run/size_config.dart';
import 'package:should_i_run/components/form_error.dart';
import 'package:should_i_run/components/default_button.dart';
import 'package:should_i_run/model/weather_response.dart';
import 'package:should_i_run/model/api_handler.dart';
import 'package:should_i_run/model/scorer.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:should_i_run/model/forecast_scorer.dart';

class LocationForm extends StatefulWidget {
  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final _formKey = GlobalKey<FormState>();
  final locationFormFieldController = TextEditingController();
  String location;
  String initialLocation;
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
    });
  }

  void saveInitialLocation() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('initialLocation', location);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          buildLocationFormField(),
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
          SizedBox(height: getProportionateScreenHeight(20)),
          FormError(errors: errors),
          DefaultButton(
              text: "Calculate Score",
              press: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  processApi(location);
                }
              }),
          SizedBox(height: getProportionateScreenHeight(40)),
          FutureBuilder<WeatherResponse>(
              future: weatherResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Scorer scorer = new Scorer(snapshot.data);
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
          SizedBox(height: getProportionateScreenHeight(20)),
          Visibility(
            visible: !calculateForecast,
            child: buildLocationFutureBuilder(),
          ),
          Visibility(
            visible: !calculateForecast,
            child: SizedBox(height: getProportionateScreenHeight(20)),
          ),
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
          } else if (snapshot.hasError) {
            return Text('');
          }
          return Text('');
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

  FutureBuilder<WeatherResponse> buildTestFutureBuilder() {
    return FutureBuilder<WeatherResponse>(
        future: weatherResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.dayOneHourData[23]['temp_c'].toString(),
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
            String localHour = getHourFromLocalTime(snapshot.data.localTime);
            Map scoreHourMap = createScoreHourMapFromWeatherResponse(snapshot);
            for (String h in scoreHourMap.keys.toList()) {
              if (int.parse(h) < int.parse(localHour) ||
                  int.parse(h) > (int.parse(localHour) + 24)) {
                scoreHourMap.removeWhere((key, value) => key == h);
              }
            }
            List<String> hours = scoreHourMap.keys.toList();
            List<double> scores = scoreHourMap.values.toList();
            return LineGraph(
              features: [
                Feature(
                  title: "Scores",
                  color: kPrimaryColor,
                  data: scores,
                )
              ],
              size: Size(600, 200),
              labelX: hours,
              labelY: ['25', '50', '75', '100'],
              graphColor: Colors.black87,
            );
          } else if (snapshot.hasError) {
            return Text('');
          }
          return Text('');
        });
  }

  Map<String, double> createScoreHourMapFromWeatherResponse(
      AsyncSnapshot<WeatherResponse> snap) {
    Map scoreHourMap = Map<String, double>();

    if (snap.hasData) {
      for (var i = 0; i < 24; i++) {
        double temp = snap.data.dayOneHourData[i]['temp_c'];
        double precip = snap.data.dayOneHourData[i]['precip_mm'];
        int airqu = snap.data.airQualityResult;
        int humid = snap.data.dayOneHourData[i]['humidity'];
        ForecastScorer fcScorer =
            new ForecastScorer(temp, precip, airqu, humid.toDouble());
        fcScorer.calcScore();
        scoreHourMap[i.toString()] = fcScorer.getScore().toDouble() / 100.0;
      }
      for (var i = 0; i < 24; i++) {
        double temp = snap.data.dayTwoHourData[i]['temp_c'];
        double precip = snap.data.dayTwoHourData[i]['precip_mm'];
        int airqu = snap.data.airQualityResult;
        int humid = snap.data.dayTwoHourData[i]['humidity'];
        ForecastScorer fcScorer =
            new ForecastScorer(temp, precip, airqu, humid.toDouble());
        fcScorer.calcScore();
        scoreHourMap[(i + 24).toString()] =
            fcScorer.getScore().toDouble() / 100.0;
      }
    } else if (snap.hasError) {
      return null;
    }
    return scoreHourMap;
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
          labelText: "Location",
          hintText: "Enter your location",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(
            svgIcon: "assets/icons/Location point.svg",
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

  String getHourFromLocalTime(String localTime) {
    String hour = localTime.split(' ')[1].split(':')[0];
    return hour;
  }
}
