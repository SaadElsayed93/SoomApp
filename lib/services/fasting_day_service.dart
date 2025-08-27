import 'package:hijri/hijri_calendar.dart';
import '../models/fasting_day.dart';

class FastingDayService {
  /// 🔹 بداية الأسبوع الحالي (من السبت)
  DateTime getStartOfCurrentWeek() {
    DateTime now = DateTime.now();
    int weekday = now.weekday % 7; // السبت = 0
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: weekday));
  }

  /// 🔹 بداية أسبوع معين
  DateTime getStartOfWeek(DateTime date) {
    int weekday = date.weekday % 7;
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday));
  }

  /// 🔹 كل أيام الأسبوع من تاريخ البداية
  List<FastingDay> getWeekDays(DateTime startOfWeek) {
    return List.generate(7, (index) {
      final day = startOfWeek.add(Duration(days: index));
      return getDayInfo(day);
    });
  }

  /// 🔹 معلومات اليوم (واجب، سنة، محرم...)
  FastingDay getDayInfo(DateTime date) {
    final weekday = date.weekday;
    final hijri = HijriCalendar.fromDate(date);

    // 🔹 رمضان
    if (hijri.hMonth == 9) {
      return FastingDay(
        date: date,
        type: FastingType.obligatory,
        note: "صيام رمضان واجب",
        hadith: "من صام رمضان إيماناً واحتساباً غُفر له ما تقدم من ذنبه.",
      );
    }

    // 🔹 الإثنين والخميس
    if (weekday == DateTime.monday || weekday == DateTime.thursday) {
      return FastingDay(
        date: date,
        type: FastingType.recommended,
        note: "صيام الإثنين والخميس سنة",
        hadith:
            "تُعرض الأعمال يوم الإثنين والخميس فأحب أن يُعرض عملي وأنا صائم.",
      );
    }

    // 🔹 الأيام البيض
    if (hijri.hDay == 13 || hijri.hDay == 14 || hijri.hDay == 15) {
      return FastingDay(
        date: date,
        type: FastingType.recommended,
        note: "صيام الأيام البيض (13-14-15 من كل شهر هجري)",
        hadith: "صيام الأيام البيض سنة، وكان النبي ﷺ يصومها.",
      );
    }

    // 🔹 يوم عرفة
    if (hijri.hMonth == 12 && hijri.hDay == 9) {
      return FastingDay(
        date: date,
        type: FastingType.recommended,
        note: "صيام يوم عرفة يكفّر سنتين",
        hadith:
            "صيام يوم عرفة أحتسب على الله أن يكفر السنة التي قبله والتي بعده.",
      );
    }

    // 🔹 عاشوراء
    if (hijri.hMonth == 1 && hijri.hDay == 10) {
      return FastingDay(
        date: date,
        type: FastingType.recommended,
        note: "صيام عاشوراء يكفّر السنة الماضية",
        hadith: "صيام يوم عاشوراء يكفر السنة الماضية.",
      );
    }

    // 🔹 ست شوال
    if (hijri.hMonth == 10 && hijri.hDay >= 2 && hijri.hDay <= 7) {
      return FastingDay(
        date: date,
        type: FastingType.recommended,
        note: "ستة أيام من شوال بعد العيد",
        hadith:
            "من صام رمضان ثم أتبعه ستة أيام من شوال كان كصيام الدهر.",
      );
    }

    // 🔹 العيدين
    if ((hijri.hMonth == 10 && hijri.hDay == 1) ||
        (hijri.hMonth == 12 && hijri.hDay == 10)) {
      return FastingDay(
        date: date,
        type: FastingType.forbidden,
        note: "صيام يوم العيد منهي عنه",
        hadith: "لا يجوز صيام يوم العيد.",
      );
    }

    // 🔹 أيام التشريق
    if (hijri.hMonth == 12 &&
        (hijri.hDay == 11 || hijri.hDay == 12 || hijri.hDay == 13)) {
      return FastingDay(
        date: date,
        type: FastingType.forbidden,
        note: "أيام التشريق لا يجوز صيامها",
        hadith:
            "أيام التشريق أيام أكل وشرب وذكر الله، لا يجوز صيامها.",
      );
    }

    // 🔹 إفراد الجمعة
    if (weekday == DateTime.friday) {
      return FastingDay(
        date: date,
        type: FastingType.forbidden,
        note: "منهي عن إفراد الجمعة بالصيام",
        hadith: "لا يُستحب صيام يوم الجمعة منفرداً.",
      );
    }

    // 🔹 باقي الأيام
    return FastingDay(
      date: date,
      type: FastingType.normal,
      note: "لا يوجد حكم خاص لهذا اليوم",
      hadith: null,
    );
  }

  /// 🔹 جلب أيام الشهر الهجري
  List<FastingDay> getHijriMonthDays(int hYear, int hMonth) {
    final List<FastingDay> days = [];

    final daysInMonth = HijriCalendar().getDaysInMonth(hYear, hMonth);

    for (int i = 1; i <= daysInMonth; i++) {
      final hijri = HijriCalendar()
        ..hYear = hYear
        ..hMonth = hMonth
        ..hDay = i;

      // ✅ تحويل للميلادي
      final gregorian =
          hijri.hijriToGregorian(hijri.hYear, hijri.hMonth, hijri.hDay);

      days.add(getDayInfo(gregorian));
    }

    return days;
  }
}
