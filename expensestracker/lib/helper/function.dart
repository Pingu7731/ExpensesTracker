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
