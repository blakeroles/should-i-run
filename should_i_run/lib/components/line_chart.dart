import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:should_i_run/constants.dart';

// This class has been adapted from line_chart_sample5.dart
// located within the fl_chart Github repository.

class ForecastChart extends StatelessWidget {
  final List<int> showIndexes = const [1, 3, 5];
  final List<FlSpot> allSpots = [
    FlSpot(0, 1),
    FlSpot(1, 2),
    FlSpot(2, 1.5),
    FlSpot(3, 3),
    FlSpot(4, 3.5),
    FlSpot(5, 5),
    FlSpot(6, 8),
  ];

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showIndexes,
        spots: allSpots,
        isCurved: false,
        barWidth: 2,
        //shadow: const Shadow(
        //blurRadius: 8,
        //color: Colors.black,
        //),
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
        //colorStops: [
        //  0.1,
        //  0.4,
        //  0.9
        //]
      ),
    ];

    //final tooltipsOnBar = lineBarsData[0];

    return SizedBox(
      width: 300,
      height: 200,
      child: LineChart(
        LineChartData(
          //showingTooltipIndicators: showIndexes.map((index) {
          //  return ShowingTooltipIndicators([
          //    LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar),
          //        tooltipsOnBar.spots[index]),
          //  ]);
          //}).toList(),
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
                      color: lerpGradient(
                          barData.colors, barData.colorStops, percent / 100),
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
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: lineBarsData,
          minY: 0,
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: false,
            ),
            bottomTitles: SideTitles(
                showTitles: true,
                getTitles: (val) {
                  switch (val.toInt()) {
                    case 0:
                      return '00:00';
                    case 1:
                      return '04:00';
                    case 2:
                      return '08:00';
                    case 3:
                      return '12:00';
                    case 4:
                      return '16:00';
                    case 5:
                      return '20:00';
                    case 6:
                      return '23:59';
                  }
                  return '';
                },
                getTextStyles: (context, value) => const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      fontFamily: 'Digital',
                      fontSize: 12,
                    )),
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
          ),
          axisTitleData: FlAxisTitleData(
            //rightTitle: AxisTitle(showTitle: true, titleText: 'count'),
            leftTitle: AxisTitle(showTitle: true, titleText: 'Score'),
            topTitle: AxisTitle(
                showTitle: true,
                titleText: 'Forecasted scores over next 24hrs',
                textAlign: TextAlign.center),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
          ),
        ),
      ),
    );
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
