import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class DateHelper {
  static final Map<String, String> _hijriMonthsMap = {
    "Muharram": "محرم",
    "Safar": "صفر",
    "Rabi al-Awwal": "ربيع الأول",
    "Rabi al-Thani": "ربيع الآخر",
    "Jumada al-Awwal": "جمادى الأولى",
    "Jumada al-Thani": "جمادى الآخرة",
    "Rajab": "رجب",
    "Shaban": "شعبان",
    "Ramadan": "رمضان",
    "Shawwal": "شوال",
    "Dhul-Qadah": "ذو القعدة",
    "Dhul-Hijjah": "ذو الحجة",
  };

  static String getDayName(DateTime date) {
    const names = {
      1: "الاثنين",
      2: "الثلاثاء",
      3: "الأربعاء",
      4: "الخميس",
      5: "الجمعة",
      6: "السبت",
      7: "الأحد",
    };
    return names[date.weekday] ?? "";
  }

  static String formatHijri(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    String raw = hijri.toFormat("dd MMMM yyyy");
    _hijriMonthsMap.forEach((en, ar) {
      raw = raw.replaceAll(en, ar);
    });
    return "$raw هـ";
  }

  static String formatDate(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }

  static String formatGregorian(DateTime date) {
    try {
      return DateFormat("d MMMM yyyy", "ar").format(date);
    } catch (_) {
      return DateFormat("d MMMM yyyy").format(date);
    }
  }
}
