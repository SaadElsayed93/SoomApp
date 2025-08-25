import 'package:flutter/material.dart';
import '../models/fasting_day.dart';
import '../widgets/fasting_day_card.dart';
import '../services/fasting_day_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedWeekStart = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedWeekStart = DateTime.now()
        .subtract(Duration(days: DateTime.now().weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final days = FastingDayService.getWeekDays(selectedWeekStart);
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text("أيام الصيام")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: days.length,
              itemBuilder: (context, i) {
                final isToday = days[i].date.day == today.day &&
                    days[i].date.month == today.month &&
                    days[i].date.year == today.year;
                return FastingDayCard(day: days[i], isToday: isToday);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedWeekStart =
                          selectedWeekStart.subtract(const Duration(days: 7));
                    });
                  },
                  child: const Text("الأسبوع السابق"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      final now = DateTime.now();
                      selectedWeekStart =
                          now.subtract(Duration(days: now.weekday - 1));
                    });
                  },
                  child: const Text("الأسبوع الحالي"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedWeekStart =
                          selectedWeekStart.add(const Duration(days: 7));
                    });
                  },
                  child: const Text("الأسبوع القادم"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
