import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:should_i_run/constants.dart';
import 'package:should_i_run/model/weather_response.dart';
import 'package:should_i_run/model/forecast_scorer.dart';

// This class has been adapted from line_chart_sample5.dart
// located within the fl_chart Github repository.

// ignore: must_be_immutable
class ForecastChart extends StatelessWidget {
  List<FlSpot> allSpots = [];
  Future<WeatherResponse> weatherResponse;

  ForecastChart(Future<WeatherResponse> wR) {
    this.weatherResponse = wR;
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        spots: allSpots,
        isCurved: false,
        barWidth: 4,
        belowBarData: BarAreaData(
          show: true,
          colors: [
            kPrimaryColor,
          ],
        ),
        dotData: FlDotData(show: false),
        colors: [
          kPrimaryColor,
        ],
      ),
    ];

    return FutureBuilder<WeatherResponse>(
        future: weatherResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String localHour = getHourFromLocalTime(snapshot.data.localTime);
            Map scoreHourMap = createScoreHourMapFromWeatherResponse(snapshot);
            for (int h in scoreHourMap.keys.toList()) {
              if (h < int.parse(localHour) || h > (int.parse(localHour) + 24)) {
                scoreHourMap.removeWhere((key, value) => key == h);
              }
            }
            for (int h in scoreHourMap.keys.toList()) {
              allSpots.add(FlSpot(h.toDouble(), scoreHourMap[h]));
            }
            return SizedBox(
              width: 300,
              height: 180,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    enabled: true,
                    getTouchedSpotIndicator:
                        (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((index) {
                        return TouchedSpotIndicatorData(
                          FlLine(
                            color: kPrimaryColor,
                          ),
                          FlDotData(
                            show: false,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              radius: 8,
                              color: lerpGradient(barData.colors,
                                  barData.colorStops, percent / 100),
                              strokeWidth: 2,
                              strokeColor: Colors.black,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: kPrimaryColor,
                      tooltipRoundedRadius: 4,
                      getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                        return lineBarsSpot.map((lineBarSpot) {
                          return LineTooltipItem(
                            lineBarSpot.y.toString(),
                            const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: lineBarsData,
                  minY: 0,
                  maxY: 100,
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                              fontSize: 10,
                            )),
                    bottomTitles: SideTitles(
                        showTitles: true,
                        getTitles: (val) {
                          if (val.toInt() < 24) {
                            return val.toInt().toString() + ':00';
                          } else {
                            return (val.toInt() - 24).toString() + ':00';
                          }
                        },
                        getTextStyles: (context, value) => const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                              fontFamily: 'Digital',
                              fontSize: 10,
                            )),
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                  ),
                  axisTitleData: FlAxisTitleData(
                    topTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'Forecasted score over next 24hrs',
                        textAlign: TextAlign.center),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(
                    show: true,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('');
          }
          return Text('');
        });
  }

  String getHourFromLocalTime(String localTime) {
    String hour = localTime.split(' ')[1].split(':')[0];
    return hour;
  }

  Map<int, double> createScoreHourMapFromWeatherResponse(
      AsyncSnapshot<WeatherResponse> snap) {
    Map scoreHourMap = Map<int, double>();

    if (snap.hasData) {
      for (var i = 0; i < 24; i++) {
        double temp = snap.data.dayOneHourData[i]['temp_c'];
        double precip = snap.data.dayOneHourData[i]['precip_mm'];
        int airqu = snap.data.airQualityResult;
        int humid = snap.data.dayOneHourData[i]['humidity'];
        ForecastScorer fcScorer =
            new ForecastScorer(temp, precip, airqu, humid.toDouble());
        fcScorer.calcScore();
        scoreHourMap[i] = fcScorer.getScore().toDouble();
      }
      for (var i = 0; i < 24; i++) {
        double temp = snap.data.dayTwoHourData[i]['temp_c'];
        double precip = snap.data.dayTwoHourData[i]['precip_mm'];
        int airqu = snap.data.airQualityResult;
        int humid = snap.data.dayTwoHourData[i]['humidity'];
        ForecastScorer fcScorer =
            new ForecastScorer(temp, precip, airqu, humid.toDouble());
        fcScorer.calcScore();
        scoreHourMap[(i + 24)] = fcScorer.getScore().toDouble();
      }
    } else if (snap.hasError) {
      return null;
    }
    return scoreHourMap;
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s], rightStop = stops[s + 1];
    final leftColor = colors[s], rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT);
    }
  }
  return colors.last;
}
