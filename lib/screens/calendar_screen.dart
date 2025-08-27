import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../services/fasting_day_service.dart';
import '../models/fasting_day.dart';

const Map<int, String> hijriMonthsArabic = {
  1: "محرم",
  2: "صفر",
  3: "ربيع الأول",
  4: "ربيع الآخر",
  5: "جمادى الأولى",
  6: "جمادى الآخرة",
  7: "رجب",
  8: "شعبان",
  9: "رمضان",
  10: "شوال",
  11: "ذو القعدة",
  12: "ذو الحجة",
};

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
        _currentHijriMonth = HijriCalendar()
          ..hYear = _currentHijriMonth.hYear + 1
          ..hMonth = 1
          ..hDay = 1;
      } else {
        _currentHijriMonth = HijriCalendar()
          ..hYear = _currentHijriMonth.hYear
          ..hMonth = _currentHijriMonth.hMonth + 1
          ..hDay = 1;
      }
    });
  }

  void _prevMonth() {
    setState(() {
      if (_currentHijriMonth.hMonth == 1) {
        _currentHijriMonth = HijriCalendar()
          ..hYear = _currentHijriMonth.hYear - 1
          ..hMonth = 12
          ..hDay = 1;
      } else {
        _currentHijriMonth = HijriCalendar()
          ..hYear = _currentHijriMonth.hYear
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
      appBar: AppBar(title: const Text("التقويم الهجري"), centerTitle: true),
      body: Column(
        children: [
          // 🔹 الهيدر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _prevMonth,
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                "${hijriMonthsArabic[_currentHijriMonth.hMonth]} ${_currentHijriMonth.hYear}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 أسماء الأيام
          Container(
            color: Colors.grey.shade200,
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                if (index < startWeekday) {
                  return const SizedBox();
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
                        Text(
                          "${hijri.hDay}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${day.date.day}/${day.date.month}",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
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

  /// 🎨 تحديد اللون المناسب
  Color _getDayColor(FastingDay day) {
    final today = DateTime.now();
    final isPast = day.date.isBefore(DateTime(today.year, today.month, today.day));

    Color base;
    switch (day.type) {
      case FastingType.obligatory:
        base = Colors.green.shade300;
        break;
      case FastingType.recommended:
        base = Colors.blue.shade300;
        break;
      case FastingType.forbidden:
        base = Colors.red.shade300;
        break;
      case FastingType.normal:
      default:
        base = Colors.grey.shade200;
        break;
    }

    return isPast ? base.withOpacity(0.4) : base; // 👈 لو اليوم فات يبقى اللون أفتح
  }

  /// 🔹 BottomSheet تفاصيل اليوم
  void _showDayDetails(BuildContext context, FastingDay day, HijriCalendar hijri) {
    String typeText;
    switch (day.type) {
      case FastingType.obligatory:
        typeText = "صوم واجب";
        break;
      case FastingType.recommended:
        typeText = "صوم مستحب";
        break;
      case FastingType.forbidden:
        typeText = "صوم ممنوع";
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
              "اليوم ${hijri.hDay} ${hijriMonthsArabic[hijri.hMonth]} ${hijri.hYear} هـ",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("📅 الميلادي: ${day.date.day}/${day.date.month}/${day.date.year}"),
            const SizedBox(height: 10),
            Text("📌 النوع: $typeText", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 15),
            const Text(
              "📖 حديث أو فائدة عن الصيام يوضع هنا ...",
              style: TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إغلاق"),
            )
          ],
        ),
      ),
    );
  }
}
