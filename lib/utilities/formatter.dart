import 'package:intl/intl.dart';

class Formatter {
  static String formatCurrency(num amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(amount);
  }
}
