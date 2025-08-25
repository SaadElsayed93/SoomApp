import 'package:flutter/material.dart';
import '../models/fasting_day.dart';
import '../core/utils/date_helper.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class FastingDetailScreen extends StatelessWidget {
  final FastingDay day;

  const FastingDetailScreen({super.key, required this.day});

 Color _getStatusColor() {
  switch (day.type) {
    case FastingType.obligatory: // رمضان
      return Colors.green.shade700;
    case FastingType.recommended:
      return Colors.green;
    case FastingType.forbidden:
      return Colors.red;
    case FastingType.normal:
    default:
      return Colors.grey;
  }
}

String _getStatusText() {
  switch (day.type) {
    case FastingType.obligatory:
      return "واجب صيامه"; // رمضان
    case FastingType.recommended:
      return "مستحب";
    case FastingType.forbidden:
      return "منهي";
    case FastingType.normal:
    default:
      return "عادي";
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل اليوم"),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🟢 اليوم نفسه كبير
            Text(
              DateHelper.getWeekdayName(day.date),
              style: AppTextStyles.title.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Banner الحالة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getStatusColor(),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    _getStatusText(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (day.note != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      day.note!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // التواريخ
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("📅 التاريخ الهجري", style: AppTextStyles.subtitle),
                    const SizedBox(height: 4),
                    Text(DateHelper.formatHijri(day.date),
                        style: AppTextStyles.title
                            .copyWith(color: AppColors.primary)),
                    const Divider(height: 30),
                    Text("📅 التاريخ الميلادي", style: AppTextStyles.subtitle),
                    const SizedBox(height: 4),
                    Text(DateHelper.formatDate(day.date),
                        style: AppTextStyles.title),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // الحديث (لو موجود)
            if (day.hadith != null)
              Card(
                color: Colors.amber.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "📖 ${day.hadith!}",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
