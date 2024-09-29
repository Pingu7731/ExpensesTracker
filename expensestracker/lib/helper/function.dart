import 'package:intl/intl.dart';

double convertDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

String changenumberwithicon(double amount) {
  final changeFormat =
      NumberFormat.currency(locale: "en_US", symbol: "\$", decimalDigits: 2);
  return changeFormat.format(amount);
}

int caulcMonthCount(int startyear, startmonth, currentyear, currentmonth) {
  int monthcount =
      (currentyear - startyear) * 12 + currentmonth - startmonth + 1;
  return monthcount;
}

String getcurrentMonthname() {
  DateTime now = DateTime.now();
  List<String> month = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC",
  ];
  return month[now.month - 1];
}
