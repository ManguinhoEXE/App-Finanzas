import 'package:intl/intl.dart';

String getMonthAbbreviation(int month, String locale) {
  final date = DateTime(2024, month, 1);
  return DateFormat.MMM(locale).format(date);
}

String getMonthFullName(int month, String locale) {
  final date = DateTime(2024, month, 1);
  return DateFormat.MMMM(locale).format(date);
}
