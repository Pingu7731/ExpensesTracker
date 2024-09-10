import 'package:expensestracker/BarGraph/thebar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Bargraph extends StatefulWidget {
  final List<double> monthSum;
  final int startmonth;

  const Bargraph({
    super.key,
    required this.monthSum,
    required this.startmonth,
  });

  @override
  State<Bargraph> createState() => _BargraphState();
}

class _BargraphState extends State<Bargraph> {
  //list to hold bardata
  List<TheBar> barData = [];

  // init bar data
  void initbar() {
    barData = List.generate(
      widget.monthSum.length,
      (index) => TheBar(x: index, y: widget.monthSum[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 2,
        maxY: 100,
      ),
    );
  }
}
