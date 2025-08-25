import 'package:hijri/hijri_calendar.dart';
import '../models/fasting_day.dart';

class FastingDayService {
  DateTime getStartOfCurrentWeek() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    int daysFromSaturday = (weekday % 7);
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: daysFromSaturday));
  }

  DateTime getStartOfWeek(DateTime date) {
    int weekday = date.weekday;
    int daysFromSaturday = (weekday % 7);
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: daysFromSaturday));
  }

  List<FastingDay> getWeekDays(DateTime startOfWeek) {
    return List.generate(7, (index) {
      final day = startOfWeek.add(Duration(days: index));
      return getDayInfo(day);
    });
  }

  FastingDay getDayInfo(DateTime date) {
    final weekday = date.weekday;
    final hijri = HijriCalendar.fromDate(date);

    // 🔹 صيام رمضان واجب
    if (hijri.hMonth == 9) {
      return FastingDay(
        date: date,
        type: FastingType.obligatory,
        note: "صيام رمضان واجب",
        hadith: "من صام رمضان إيماناً واحتساباً غُفر له ما تقدم من ذنبه.",
      );
    }

    // ✅ الإثنين والخميس
    if (weekday == DateTime.monday || weekday == DateTime.thursday) {
      return FastingDay(
        date: date,
        type: FastingType.recommended,
        note: "صيام الإثنين والخميس سنة",
        hadith: "تُعرض الأعمال يوم الإثنين والخميس فأحب أن يُعرض عملي وأنا صائم.",
      );
    }

    // ✅ الأيام البيض (13–14–15 هجري)
    if (hijri.hDay == 13 || hijri.hDay == 14 || hijri.hDay == 15) {
      return FastingDay(
        date: date,
        type: FastingType.recommended,
        note: "صيام الأيام البيض (13-14-15 من كل شهر هجري)",
        hadith: "صيام الأيام البيض سنة، وكان النبي ﷺ يصومها.",
      );
    }

    // ✅ يوم عرفة (9 ذو الحجة)
    if (hijri.hMonth == 12 && hijri.hDay == 9) {
      return FastingDay(
        date: date,
        type: FastingType.recommended,
        note: "صيام يوم عرفة يكفّر سنتين",
        hadith: "صيام يوم عرفة أحتسب على الله أن يكفر السنة التي قبله والتي بعده.",
      );
    }

    // ✅ يوم عاشوراء (10 محرم)
    if (hijri.hMonth == 1 && hijri.hDay == 10) {
      return FastingDay(
        date: date,
        type: FastingType.recommended,
        note: "صيام عاشوراء يكفّر السنة الماضية",
        hadith: "صيام يوم عاشوراء يكفر السنة الماضية.",
      );
    }

    // ✅ ست شوال (2–7 شوال)
    if (hijri.hMonth == 10 && hijri.hDay >= 2 && hijri.hDay <= 7) {
      return FastingDay(
        date: date,
        type: FastingType.recommended,
        note: "ستة أيام من شوال بعد العيد",
        hadith: "من صام رمضان ثم أتبعه ستة أيام من شوال كان كصيام الدهر.",
      );
    }

    // ⛔ يوم العيد (1 شوال أو 10 ذو الحجة)
    if ((hijri.hMonth == 10 && hijri.hDay == 1) ||
        (hijri.hMonth == 12 && hijri.hDay == 10)) {
      return FastingDay(
        date: date,
        type: FastingType.forbidden,
        note: "صيام يوم العيد منهي عنه",
        hadith: "لا يجوز صيام يوم العيد.",
      );
    }

    // ⛔ أيام التشريق (11–12–13 ذو الحجة)
    if (hijri.hMonth == 12 &&
        (hijri.hDay == 11 || hijri.hDay == 12 || hijri.hDay == 13)) {
      return FastingDay(
        date: date,
        type: FastingType.forbidden,
        note: "أيام التشريق لا يجوز صيامها",
        hadith: "أيام التشريق أيام أكل وشرب وذكر الله، لا يجوز صيامها.",
      );
    }

    // ⛔ إفراد الجمعة
    if (weekday == DateTime.friday) {
      return FastingDay(
        date: date,
        type: FastingType.forbidden,
        note: "منهي عن إفراد الجمعة بالصيام",
        hadith: "لا يُستحب صيام يوم الجمعة منفرداً.",
      );
    }

    // ⚪ باقي الأيام عادية
    return FastingDay(
      date: date,
      type: FastingType.normal,
      note: "لا يوجد حكم خاص لهذا اليوم",
      hadith: null,
    );
  }
}
