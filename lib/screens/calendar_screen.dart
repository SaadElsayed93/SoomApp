import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../services/fasting_day_service.dart';
import '../models/fasting_day.dart';
import '../core/utils/date_helper.dart';
import '../core/theme/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FastingDayService _service = FastingDayService();
  late HijriCalendar _currentHijriMonth;
  final HijriCalendar _todayHijri = HijriCalendar.now();

  @override
  void initState() {
    super.initState();
    _currentHijriMonth = HijriCalendar.now();
  }

  void _nextMonth() {
    setState(() {
      if (_currentHijriMonth.hMonth == 12) {
        _currentHijriMonth
          ..hYear = _currentHijriMonth.hYear + 1
          ..hMonth = 1
          ..hDay = 1;
      } else {
        _currentHijriMonth
          ..hMonth = _currentHijriMonth.hMonth + 1
          ..hDay = 1;
      }
    });
  }

  void _prevMonth() {
    setState(() {
      if (_currentHijriMonth.hMonth == 1) {
        _currentHijriMonth
          ..hYear = _currentHijriMonth.hYear - 1
          ..hMonth = 12
          ..hDay = 1;
      } else {
        _currentHijriMonth
          ..hMonth = _currentHijriMonth.hMonth - 1
          ..hDay = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _service.getHijriMonthDays(
      _currentHijriMonth.hYear,
      _currentHijriMonth.hMonth,
    );

    // عشان نعرف في أي يوم يبدأ الشهر
    final firstDayHijri = HijriCalendar()
      ..hYear = _currentHijriMonth.hYear
      ..hMonth = _currentHijriMonth.hMonth
      ..hDay = 1;

    final firstDayGregorian = firstDayHijri.hijriToGregorian(
      firstDayHijri.hYear,
      firstDayHijri.hMonth,
      firstDayHijri.hDay,
    );

    final startWeekday = firstDayGregorian.weekday % 7; // السبت = 0

    return Scaffold(
      appBar: AppBar(
        title: const Text("📅 التقويم الهجري"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // 🔹 الهيدر
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _prevMonth,
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                ),
                Text(
                  "${DateHelper.getHijriMonthName(_currentHijriMonth.hMonth)} ${_currentHijriMonth.hYear}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.arrow_forward, color: AppColors.textDark),
                ),
              ],
            ),
          ),

          // 🔹 أسماء الأيام
          Container(
            color: AppColors.normalDay,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: const [
                Expanded(child: Center(child: Text("السبت", style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text("الأحد", style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text("الإثنين", style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text("الثلاثاء", style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text("الأربعاء", style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text("الخميس", style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text("الجمعة", style: TextStyle(fontWeight: FontWeight.bold)))),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // 🔹 الشبكة
          Expanded(
            child: GridView.builder(
              itemCount: days.length + startWeekday,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemBuilder: (context, index) {
                if (index < startWeekday) {
                  return const SizedBox(); // فراغ قبل أول يوم
                }

                final day = days[index - startWeekday];
                final hijri = HijriCalendar.fromDate(day.date);

                return GestureDetector(
                  onTap: () => _showDayDetails(context, day, hijri),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _getDayColor(day),
                      borderRadius: BorderRadius.circular(6),
                      border: (hijri.hYear == _todayHijri.hYear &&
                              hijri.hMonth == _todayHijri.hMonth &&
                              hijri.hDay == _todayHijri.hDay)
                          ? Border.all(color: Colors.orange, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${hijri.hDay}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          "${day.date.day}/${day.date.month}",
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 اللون حسب النوع (مع تخفيف الأيام الماضية)
  Color _getDayColor(FastingDay day) {
    final today = DateTime.now();
    final isPast = day.date.isBefore(DateTime(today.year, today.month, today.day));

    Color base;
    switch (day.type) {
      case FastingType.obligatory:
        base = AppColors.obligatoryFasting;
        break;
      case FastingType.recommended:
        base = AppColors.recommendedFasting;
        break;
      case FastingType.forbidden:
        base = AppColors.forbiddenFasting;
        break;
      case FastingType.normal:
      default:
        base = AppColors.normalDay;
        break;
    }

    return isPast ? base.withOpacity(0.4) : base;
  }

  /// 🔹 BottomSheet تفاصيل اليوم
  void _showDayDetails(BuildContext context, FastingDay day, HijriCalendar hijri) {
    String typeText;
    switch (day.type) {
      case FastingType.obligatory:
        typeText = "📌 صوم واجب";
        break;
      case FastingType.recommended:
        typeText = "🌿 صوم مستحب";
        break;
      case FastingType.forbidden:
        typeText = "🚫 صوم ممنوع";
        break;
      case FastingType.normal:
      default:
        typeText = "يوم عادي";
        break;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "اليوم ${hijri.hDay} ${DateHelper.getHijriMonthName(hijri.hMonth)} ${hijri.hYear} هـ",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("📅 الميلادي: ${day.date.day}/${day.date.month}/${day.date.year}"),
            const SizedBox(height: 10),
            Text("📌 النوع: $typeText", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 15),
            Text(day.note ?? "لا يوجد ملاحظة", style: const TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () => Navigator.pop(context),
              child: const Text("إغلاق"),
            )
          ],
        ),
      ),
    );
  }
}
