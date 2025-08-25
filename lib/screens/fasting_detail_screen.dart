import 'package:flutter/material.dart';
import '../models/fasting_day.dart';
import '../core/utils/date_helper.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class FastingDetailScreen extends StatelessWidget {
  final FastingDay day;

  const FastingDetailScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    Color bannerColor;
    String statusText;
    IconData statusIcon;

    switch (day.type) {
      case FastingType.recommended:
        bannerColor = Colors.green.shade600;
        statusText = "✅ يوم مستحب صيامه";
        statusIcon = Icons.check_circle;
        break;
      case FastingType.forbidden:
        bannerColor = Colors.red.shade600;
        statusText = "⛔ يوم منهي عن صيامه";
        statusIcon = Icons.block;
        break;
      default:
        bannerColor = Colors.grey.shade600;
        statusText = "⚪ يوم عادي";
        statusIcon = Icons.info;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل اليوم"),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bannerColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(statusIcon, color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  Text(statusText,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                    Text(DateHelper.formatGregorian(day.date),
                        style: AppTextStyles.title),
                  ],
                ),
              ),
            ),
            if (day.note != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bannerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(day.note!,
                    style: AppTextStyles.body
                        .copyWith(fontSize: 16, color: bannerColor),
                    textAlign: TextAlign.center),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
