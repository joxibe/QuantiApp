import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
      decimalDigits: 0,
    ).format(value);
  }

  static String formatInputCurrency(String value) {
    if (value.isEmpty) return '';
    value = value.replaceAll(RegExp(r'[^\d]'), '');
    if (value.isEmpty) return '';
    final number = int.parse(value);
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
} 