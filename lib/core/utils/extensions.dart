extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get isEmailValid {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this) ? this : '';
  }
}

extension DoubleExtensions on double {
  String get toCurrency {
    return '\$${toStringAsFixed(2)}';
  }
}
