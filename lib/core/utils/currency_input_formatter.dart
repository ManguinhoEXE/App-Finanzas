import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue();
    }

    final formatted = _addThousandSeparators(digitsOnly);

    final selectionIndex = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  String _addThousandSeparators(String digits) {
    final buffer = StringBuffer();
    final length = digits.length;

    for (var i = 0; i < length; i++) {
      final digit = digits[i];
      final positionFromEnd = length - 1 - i;

      buffer.write(digit);

      if (positionFromEnd > 0 && positionFromEnd % 3 == 0) {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }

  static double parseFormatted(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(digitsOnly) ?? 0;
  }
}
