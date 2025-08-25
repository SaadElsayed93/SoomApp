import '../models/fasting_day.dart';

class FastingDaysData {
  static List<FastingDay> generateDays(int year, int month) {
    // هنا بنعمل مثال لشهر معين (ممكن تربطه بالتقويم الهجري بعدين)
    List<FastingDay> days = [];

    // أمثلة:
    days.add(FastingDay(
      date: DateTime(year, month, 1), // فرضًا الاثنين
      type: FastingType.recommended,
      note: "يوم الاثنين مستحب صيامه اقتداءً بالنبي ﷺ.",
    ));

    days.add(FastingDay(
      date: DateTime(year, month, 10), // عاشوراء
      type: FastingType.recommended,
      note: "صيام يوم عاشوراء يكفر سنة ماضية.",
    ));

    days.add(FastingDay(
      date: DateTime(year, month, 13),
      type: FastingType.recommended,
      note: "من الأيام البيض (13–15 هجري) التي يستحب صيامها.",
    ));

    days.add(FastingDay(
      date: DateTime(year, month, 14),
      type: FastingType.recommended,
      note: "من الأيام البيض (13–15 هجري) التي يستحب صيامها.",
    ));

    days.add(FastingDay(
      date: DateTime(year, month, 15),
      type: FastingType.recommended,
      note: "من الأيام البيض (13–15 هجري) التي يستحب صيامها.",
    ));

    // يوم عيد الأضحى
    days.add(FastingDay(
      date: DateTime(year, 6, 10), // مثال (10 ذو الحجة هجري = هنا محتاج تحويل)
      type: FastingType.forbidden,
      note: "يوم العيد منهي عن صيامه.",
    ));

    // يوم عيد الفطر
    days.add(FastingDay(
      date: DateTime(year, 4, 1), // 1 شوال (محتاج تحويل هجري → ميلادي)
      type: FastingType.forbidden,
      note: "يوم عيد الفطر منهي عن صيامه.",
    ));

    return days;
  }
}
