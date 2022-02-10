import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';
import 'package:posapp_v2/provider/models/model_daily_sale_rpt.dart';

class LineChartSample5 extends StatefulWidget {
  final List<DailySaleRptModel> model;

  const LineChartSample5({Key? key, required this.model}) : super(key: key);
  @override
  _LineChartSample5State createState() => _LineChartSample5State();
}

class _LineChartSample5State extends State<LineChartSample5> {
  // List<double> showIndexes = const [1, 3, 5];
  final List<FlSpot> allSpots2 = [];
  List<int> _showIndexes = [];
  List<DailySaleRptModel> model = [];
  List<DailySaleRptModel> _modelPlot = [];

  int yy = 0;

  @override
  void initState() {
    yy = int.tryParse(yyFormat.format(DateTime.now()))!;
    yy = yy + 43;

    model = widget.model;

    for (int i = 0; i <= 6; i++) {
      if (model.length > i) {
        var _billDt = model[i].billDt;
        var _dt = model[i].billDt.split('/');
        if (_dt.length == 3) {
          _billDt = '${_dt[0]}/${_dt[1]}';
        }
        _modelPlot.add(
          DailySaleRptModel(billDt: _billDt, amt: model[i].amt),
        );
      } else {
        _modelPlot.add(
          DailySaleRptModel(billDt: '-', amt: 0),
        );
      }
    }

    for (int i = 0; i <= _modelPlot.length - 1; i++) {
      allSpots2.add(
        FlSpot(double.parse(i.toString()), _modelPlot[i].amt!),
      );

      _showIndexes.add(i);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: _showIndexes,
        spots: allSpots2,
        isCurved: true,
        barWidth: 2,
        shadow: Shadow(
          blurRadius: 2,
          color: LIGHT_YELLOW2,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: [
            const Color(0xff756300).withOpacity(0.8),
            const Color(0xffA38A00).withOpacity(0.5),
            const Color(0xffD1B000).withOpacity(0.7),
          ],
        ),
        dotData: FlDotData(show: false),
        colors: [
          // const Color(0xff12c2e9),
          // const Color(0xffc471ed),
          LIGHT_YELLOW2,
        ],
        colorStops: [0.1, 0.3, 0.6],
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: LineChart(
          LineChartData(
            showingTooltipIndicators: _showIndexes.map((index) {
              return ShowingTooltipIndicators([
                LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar),
                    tooltipsOnBar.spots[index]),
              ]);
            }).toList(),
            lineTouchData: LineTouchData(
              enabled: false,
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: Colors.white.withOpacity(.1),
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, double percent,
                              LineChartBarData barData, index) =>
                          FlDotCirclePainter(
                        radius: 2,
                        color: lerpGradient(
                            barData.colors, barData.colorStops!, percent / 100),
                        strokeWidth: .6,
                        strokeColor: Colors.white,
                      ),
                    ),
                  );
                }).toList();
              },
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipRoundedRadius: 10,
                getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                  return lineBarsSpot.map((lineBarSpot) {
                    return LineTooltipItem(
                      numberFormat.format(lineBarSpot.y),
                      const TextStyle(
                          color: LIGHT_YELLOW2,
                          fontSize: 8,
                          fontWeight: FontWeight.bold),
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
                  var _intLbl = val.toString().split('.');
                  int _index = int.parse(_intLbl[0]);
                  String _date = _modelPlot[_index].billDt.toString();
                  return _date;
                },
                getTextStyles: (context, fontSize) {
                  return TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  );
                },
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(
              show: false,
            ),
          ),
        ),
      ),
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / colors.length;
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
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
