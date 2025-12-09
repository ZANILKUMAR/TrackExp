import 'package:intl/intl.dart';

class FormatHelper {
  static final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  static final dateFormat = DateFormat('dd MMM yyyy');
  static final monthYearFormat = DateFormat('MMMM yyyy');
  static final shortDateFormat = DateFormat('dd/MM/yy');

  static String formatCurrency(double amount) {
    return currencyFormat.format(amount);
  }

  static String formatDate(DateTime date) {
    return dateFormat.format(date);
  }

  static String formatMonthYear(DateTime date) {
    return monthYearFormat.format(date);
  }

  static String formatShortDate(DateTime date) {
    return shortDateFormat.format(date);
  }

  static String getMonthName(int month) {
    return DateFormat.MMMM().format(DateTime(2024, month));
  }
}
