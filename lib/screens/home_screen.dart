import 'package:flutter/material.dart';
import '../models/fasting_day.dart';
import '../services/fasting_day_service.dart';
import '../widgets/fasting_day_card.dart';
import '../widgets/week_navigator.dart';
import '../core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FastingDayService _service = FastingDayService();
  late DateTime _startOfWeek;

  @override
  void initState() {
    super.initState();
    _startOfWeek = _service.getStartOfCurrentWeek();
  }

  void _goToPreviousWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.add(const Duration(days: 7));
    });
  }

  void _goToCurrentWeek() {
    setState(() {
      _startOfWeek = _service.getStartOfCurrentWeek();
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _service.getWeekDays(_startOfWeek);

    return Scaffold(
      appBar: AppBar(
        title: const Text("أيام الصيام الخاصة"),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const Text(
            "تعرف مواعيد الصيام المستحبة والممنوعة",
            style: TextStyle(fontSize: 14, color: AppColors.textLight),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: days.length,
              itemBuilder: (context, index) {
                return FastingDayCard(day: days[index]);
              },
            ),
          ),

          // ✅ Week Navigator (السابق - الحالي - القادم)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: WeekNavigator(
              onPrevious: _goToPreviousWeek,
              onNext: _goToNextWeek,
              onCurrent: _goToCurrentWeek,
            ),
          ),
        ],
      ),
    );
  }
}
