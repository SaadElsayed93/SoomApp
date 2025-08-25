import 'package:hijri/hijri_calendar.dart';

enum FastingType { recommended, forbidden, none }

class FastingCalculator {
  static FastingType getFastingType(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    final day = hijri.hDay;
    final month = hijri.hMonth;
    final weekday = date.weekday;

    // الإثنين والخميس
    if (weekday == DateTime.monday || weekday == DateTime.thursday) {
      return FastingType.recommended;
    }

    // الأيام البيض
    if ([13, 14, 15].contains(day)) {
      return FastingType.recommended;
    }

    // عاشوراء
    if (month == 1 && day == 10) {
      return FastingType.recommended;
    }

    // عرفة
    if (month == 12 && day == 9) {
      return FastingType.recommended;
    }

    // العيدين
    if ((month == 10 && day == 1) || (month == 12 && day == 10)) {
      return FastingType.forbidden;
    }

    // أيام التشريق
    if (month == 12 && [11, 12, 13].contains(day)) {
      return FastingType.forbidden;
    }

    return FastingType.none;
  }
}
