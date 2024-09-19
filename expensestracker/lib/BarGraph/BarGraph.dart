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
  void initializeBar() {
    barData = List.generate(
      widget.monthSum.length,
      (index) => TheBar(x: index, y: widget.monthSum[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeBar();
    double barwidth = 20;
    double barspacing = 15;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: barwidth * barData.length + barspacing * (barData.length - 1),
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: 100,
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
                            toY: data.y,
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black,
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 100,
                              color: const Color.fromARGB(255, 235, 223, 242),
                            )),
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

Widget getbargraphtitlename(double value, TitleMeta meta) {
  String text = '';

  const textstyle = TextStyle(
    color: Colors.black,
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
