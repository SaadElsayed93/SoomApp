import 'package:flutter/material.dart';
import '../models/fasting_day.dart';
import '../core/theme/app_text_styles.dart';
import '../screens/fasting_detail_screen.dart';
import '../core/utils/date_helper.dart';
import '../core/theme/app_colors.dart';

class FastingDayCard extends StatelessWidget {
  final FastingDay day;

  const FastingDayCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    Color color;
    String status;
    switch (day.type) {
      case FastingType.recommended:
        color = AppColors.recommendedFasting;
        status = "مستحب";
        break;
      case FastingType.obligatory: // رمضان
        color = AppColors.obligatoryFasting;
        status = "واجب صيامه";
        break;
      case FastingType.forbidden:
        color = AppColors.forbiddenFasting;
        status = "منهي";
        break;
      case FastingType.normal:
      default:
        color = AppColors.normalDay;
        status = "عادي";
    }

    final isToday = day.date.year == DateTime.now().year &&
        day.date.month == DateTime.now().month &&
        day.date.day == DateTime.now().day;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: isToday ? AppColors.highlightDay : Colors.white, // ✅ اليوم الحالي بلون ثابت من الثيم
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FastingDetailScreen(day: day)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // ✅ أيقونة على الشمال
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.calendar_today, color: color),
              ),
              const SizedBox(width: 16),

              // ✅ النصوص على اليمين
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "يوم ${DateHelper.getWeekdayName(day.date)}",
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
                  ],
                ),
              ),

              // ✅ الحالة (مستحب / واجب / منهي / عادي)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
      ),
    );
  }
}
