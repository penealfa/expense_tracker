import 'package:expense_tracker/bar%20graph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;

  const MyBarGraph(
      {super.key, required this.monthlySummary, required this.startMonth});

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = List.generate(widget.monthlySummary.length,
        (index) => IndividualBar(x: index, y: widget.monthlySummary[index]));
  }

  @override
  Widget build(BuildContext context) {

    initializeBarData();
    return BarChart(BarChartData(
      minY: 0,
      maxY: 100,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles:
                SideTitles(showTitles: true, getTitlesWidget: getBottomTitles, reservedSize: 24),
          )),
      barGroups: barData
          .map(
            (data) => BarChartGroupData(
              x: data.x,
              barRods: [
                BarChartRodData(toY: data.y),
              ],
            ),
          )
          .toList(),
    ));
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const textStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  String text;
  switch (value.toInt()) {
    case 0:
      text = 'J'; // January
      break;
    case 1:
      text = 'F'; // February
      break;
    case 2:
      text = 'M'; // March
      break;
    case 3:
      text = 'A'; // April
      break;
    case 4:
      text = 'M'; // May
      break;
    case 5:
      text = 'J'; // June
      break;
    case 6:
      text = 'J'; // July
      break;
    case 7:
      text = 'A'; // August
      break;
    case 8:
      text = 'S'; // September
      break;
    case 9:
      text = 'O'; // October
      break;
    case 10:
      text = 'N'; // November
      break;
    case 11:
      text = 'D'; // December
      break;
    default:
      text = ''; // Default case, in case value is out of range
  }

  return SideTitleWidget(
    meta: TitleMeta(
        min: meta.min,
        max: meta.max,
        parentAxisSize: meta.parentAxisSize,
        axisPosition: meta.axisPosition,
        appliedInterval: meta.appliedInterval,
        sideTitles: meta.sideTitles,
        formattedValue: meta.formattedValue,
        axisSide: meta.axisSide,
        rotationQuarterTurns: meta.rotationQuarterTurns),
    child: Text(
      text,
      style: textStyle,
    ),
  );
}
