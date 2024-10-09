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

  @override
  void initState() {
    super.initState();

    //auto scroll to latest month
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => scrollToend());
  }

  // init bar data
  void initializeBar() {
    barData = List.generate(
      widget.monthSum.length,
      (index) => TheBar(x: index, y: widget.monthSum[index]),
    );
  }

  //CALC the max of graph and not letting it exceed
  double calculateMaxheight() {
    double max = 300;

    widget.monthSum.sort();
    max = widget.monthSum.last * 1.01;
    if (max < 500) {
      return 500;
    }
    return max;
  }

  //make sure it scroll to the latest month
  final ScrollController _scrollcontroller = ScrollController();
  void scrollToend() {
    (
      _scrollcontroller.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeBar();
    double barwidth = 20;
    double barspacing = 15;
    return SingleChildScrollView(
      controller: _scrollcontroller,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SizedBox(
          width: barwidth * barData.length + barspacing * (barData.length - 1),
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: calculateMaxheight(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getbargraphtitlename,
                      reservedSize: 48),
                ),
              ),
              barGroups: barData
                  .map((data) => BarChartGroupData(
                        x: data.x,
                        barRods: [
                          BarChartRodData(
                              // toY: calculateMaxheight(),
                              toY: 200,
                              width: barwidth,
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: calculateMaxheight(),
                                color: const Color.fromARGB(255, 129, 129, 130),
                              )),
                        ],
                      ))
                  .toList(),
              alignment: BarChartAlignment.center,
              groupsSpace: barspacing,
            ),
          ),
        ),
      ),
    );
  }
}

Widget getbargraphtitlename(double value, TitleMeta meta) {
  String text = '';

  const textstyle = TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  //%12 is to loop back to the first month
  switch (value.toInt() % 12) {
    case 0:
      text = 'J';
      break;
    case 1:
      text = 'F';
      break;
    case 2:
      text = 'M';
      break;
    case 3:
      text = 'A';
      break;
    case 4:
      text = 'M';
      break;
    case 5:
      text = 'J';
      break;
    case 6:
      text = 'J';
      break;
    case 7:
      text = 'A';
      break;
    case 8:
      text = 'S';
      break;
    case 9:
      text = 'O';
      break;
    case 10:
      text = 'N';
      break;
    case 11:
      text = 'D';
      break;

    default:
      'Boom';
  }
  return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: textstyle,
      ));
}
