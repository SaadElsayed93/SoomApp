import 'package:flutter/material.dart';
import '../models/fasting_day.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../screens/fasting_detail_screen.dart';
import '../core/utils/date_helper.dart';

class FastingDayCard extends StatelessWidget {
  final FastingDay day;

  const FastingDayCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    Color color;
    String status;
    switch (day.type) {
      case FastingType.recommended:
        color = Colors.green;
        status = "مستحب";
        break;
      case FastingType.obligatory: // رمضان
        color = const Color.fromARGB(255, 24, 83, 27);
        status = "واجب صيامه";
        break;
      case FastingType.forbidden:
        color = Colors.red;
        status = "منهي";
        break;
      case FastingType.normal:
      default:
        color = Colors.grey;
        status = "عادي";
    }

    final isToday = day.date.year == DateTime.now().year &&
                    day.date.month == DateTime.now().month &&
                    day.date.day == DateTime.now().day;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: isToday ? Colors.blueGrey.shade50 : Colors.white, // يوم اليوم أفتح شوية
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FastingDetailScreen(day: day)),
          );
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateHelper.getWeekdayName(day.date),
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateHelper.formatHijri(day.date),
                    style: AppTextStyles.subtitle,
                  ),
                  Text(
                    DateHelper.formatDate(day.date),
                    style: AppTextStyles.subtitle,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            if (isToday)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
