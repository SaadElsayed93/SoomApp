import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class DateHelper {
  static String formatDate(DateTime date) {
    return DateFormat('d-MM-yyyy').format(date);
  }

  static String formatHijri(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    return "${hijri.hDay} ${getHijriMonthName(hijri.hMonth)} ${hijri.hYear} هـ";
  }

  static String getWeekdayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.saturday:
        return "السبت";
      case DateTime.sunday:
        return "الأحد";
      case DateTime.monday:
        return "الإثنين";
      case DateTime.tuesday:
        return "الثلاثاء";
      case DateTime.wednesday:
        return "الأربعاء";
      case DateTime.thursday:
        return "الخميس";
      case DateTime.friday:
        return "الجمعة";
      default:
        return "";
    }
  }

  static String getHijriMonthName(int month) {
    const months = [
      "محرم",
      "صفر",
      "ربيع الأول",
      "ربيع الآخر",
      "جمادى الأولى",
      "جمادى الآخرة",
      "رجب",
      "شعبان",
      "رمضان",
      "شوال",
      "ذو القعدة",
      "ذو الحجة",
    ];
    return months[month - 1];
  }
}
