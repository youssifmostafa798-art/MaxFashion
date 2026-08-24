import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter._();

  static String formatDate(DateTime date, {String locale = 'en'}) {
    return DateFormat.yMMMd(locale).format(date);
  }

  static String formatDateTime(DateTime date, {String locale = 'en'}) {
    return DateFormat.yMMMd(locale).add_jm().format(date);
  }

  static String formatMonthYear(DateTime date, {String locale = 'en'}) {
    return DateFormat.yMMMM(locale).format(date);
  }

  static String formatDateNumeric(DateTime date, {String locale = 'en'}) {
    return DateFormat.yMd(locale).format(date);
  }
}
