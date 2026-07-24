import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _formatter = NumberFormat('#,##0', 'es_CO');

  static String format(dynamic value) {
    final doubleValue = value is String
        ? (double.tryParse(value) ?? 0)
        : (value ?? 0).toDouble();

    return '\$${_formatter.format(doubleValue)}';
  }

  static String formatCompact(dynamic value) {
    final doubleValue = value is String
        ? (double.tryParse(value) ?? 0)
        : (value ?? 0).toDouble();

    if (doubleValue >= 1000000) {
      return '\$${(doubleValue / 1000000).toStringAsFixed(1)}M';
    } else if (doubleValue >= 1000) {
      return '\$${(doubleValue / 1000).toStringAsFixed(0)}K';
    }
    return '\$${doubleValue.toStringAsFixed(0)}';
  }
}
