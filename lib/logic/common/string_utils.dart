import 'package:intl/intl.dart' hide TextDirection;

import '../../common_libs.dart';

class StringUtils {
  static String formatYr(int yr) {
    if (yr == 0) yr = 1;
    return $strings.yearFormat(yr.abs().toString(), getYrSuffix(yr));
  }

  static String formatYrMth(DateTime? date) {
    if (date != null) {
      return DateFormat('y MMMM', 'en_US').format(date); // 'y' for year, 'MMM' for abbreviated month
    } else {
      return "Present";
    }
  }

  static String getDuration(DateTime startDate, DateTime? endDate) {
    // If it's still ongoing.
    endDate ??= DateTime.now();

    int years = endDate.year - startDate.year;
    int months = endDate.month - startDate.month;

    // If the months value is negative, it means the month in the startDate is
    // later in the year than in endDate.
    // To correct this, decrement the years by 1 and add 12 months.
    if (months < 0) {
      years--;
      months += 12;
    }

    // Convert years to months if it's less than 1 year.
    if (years == 0) {
      return Intl.plural(months, one: '1 month', other: '$months months');
    }

    // If it's 10 months or more, round up the year
    if (months >= 10) {
      years++;
    }

    return Intl.plural(years, one: '1 year', other: '$years years');
  }

  static String getYrSuffix(int yr) => yr < 0 ? $strings.yearBCE : $strings.yearCE;

  /// Get language string. The only analyzed part in the Locale is language code, not country codes.
  ///
  /// Only: `Locale('en', 'country_code')`, `Locale('es', 'country_code')` & `Locale('ca', 'country_code')`
  static String getLanguage(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return 'Spanish';
      case 'ca':
        return 'Catalan';
      case 'en':
      default:
        return 'English';
    }
  }
}
