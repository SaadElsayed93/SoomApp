import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import '../models/fasting_day.dart';
import 'fasting_calculator.dart';

class FastingDayService {
  Future<List<FastingDay>> generateFastingDays(int year) async {
    List<FastingDay> days = [];
    final start = DateTime(year, 1, 1);
    final end = DateTime(year, 12, 31);
    final formatter = DateFormat('yyyy-MM-dd');

    DateTime current = start;
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      final type = FastingCalculator.getFastingType(current);
      if (type != FastingType.none) {
        final hijri = HijriCalendar.fromDate(current);
        days.add(
          FastingDay(
            date: current,
            nameAr: _getName(day: hijri, type: type, weekday: current.weekday),
            hijriDate: "${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear}",
            gregorianDate: formatter.format(current),
            type: type,
          ),
        );
      }
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  String _getName({
    required HijriCalendar day,
    required FastingType type,
    required int weekday,
  }) {
    if (type == FastingType.recommended) {
      if (day.hDay == 10 && day.hMonth == 1) return "يوم عاشوراء";
      if (day.hDay == 9 && day.hMonth == 12) return "يوم عرفة";
      if ([13, 14, 15].contains(day.hDay)) return "أيام البيض";
      if (weekday == DateTime.monday) return "الاثنين";
      if (weekday == DateTime.thursday) return "الخميس";
    } else if (type == FastingType.forbidden) {
      if (day.hDay == 1 && day.hMonth == 10) return "عيد الفطر";
      if (day.hDay == 10 && day.hMonth == 12) return "عيد الأضحى";
      if (day.hMonth == 12 && [11, 12, 13].contains(day.hDay))
        return "أيام التشريق";
    }
    return "يوم";
  }
}
