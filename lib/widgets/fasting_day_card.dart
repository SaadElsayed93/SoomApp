import 'package:flutter/material.dart';
import '../models/fasting_day.dart';
import '../core/utils/date_helper.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../screens/fasting_detail_screen.dart';

class FastingDayCard extends StatelessWidget {
  final FastingDay day;
  final bool isToday;

  const FastingDayCard({super.key, required this.day, this.isToday = false});

  @override
  Widget build(BuildContext context) {
    Color typeColor;
    switch (day.type) {
      case FastingType.recommended:
        typeColor = Colors.green.shade600;
        break;
      case FastingType.forbidden:
        typeColor = Colors.red.shade600;
        break;
      default:
        typeColor = Colors.grey.shade600;
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FastingDetailScreen(day: day)),
      ),
      child: Card(
        elevation: isToday ? 6 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isToday
              ? BorderSide(color: AppColors.primary, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(DateHelper.getDayName(day.date),
                  style: AppTextStyles.headline),
              const SizedBox(height: 8),
              Text(DateHelper.formatHijri(day.date),
                  style: AppTextStyles.subtitle),
              const SizedBox(height: 4),
              Text(DateHelper.formatGregorian(day.date),
                  style: AppTextStyles.body),
              const SizedBox(height: 8),
              Icon(Icons.circle, color: typeColor, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
