import 'package:intl/intl.dart' hide TextDirection;

import '../../common_libs.dart';

class StringUtils {
  static bool isEmpty(String? s) {
    return s == null || s.trim().isEmpty;
  }

  static bool isNotEmpty(String? s) => !isEmpty(s);

  static bool isLink(String str) =>
      str.contains(RegExp(r'^(https?:\/\/)?([\w\d_-]+)\.([\w\d_\.-]+)\/?\??([^#\n\r]*)?#?([^\n\r]*)'));

  static String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
  }

  static String printMap(Map<String, dynamic>? map) {
    String str = '';
    map?.forEach((key, value) => str += '$key: ${value.toString}, ');
    return str;
  }

  static Size measure(String text, TextStyle style, {int maxLines = 1, TextDirection direction = TextDirection.ltr}) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: text, style: style), maxLines: maxLines, textDirection: direction)
          ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static double measureLongest(List<String> items, TextStyle style, [maxItems]) {
    double l = 0;
    if (maxItems != null && maxItems < items.length) {
      items.length = maxItems;
    }
    for (var item in items) {
      double m = StringUtils.measure(item, style).width;
      if (m > l) l = m;
    }
    return l;
  }

  /// Gracefully handles null values, and skips the suffix when null
  static String safeGet(String value, [String? suffix]) {
    return value + (value.isNotEmpty ? suffix ?? '' : '');
  }

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

  static String getEra(int yr) {
    if (yr <= -600) return $strings.eraPrehistory;
    if (yr <= 476) return $strings.eraClassical;
    if (yr <= 1450) return $strings.eraEarlyModern;
    return $strings.eraModern;
  }

  static String capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
  }

  static String supplant(String value, Map<String, String> supplants) {
    return value.replaceAllMapped(RegExp(r'\{\w+\}'), (match) {
      final placeholder = match.group(0) ?? '';
      if (supplants.containsKey(placeholder)) {
        return supplants[placeholder]!;
      }
      return placeholder;
    });
  }
}
