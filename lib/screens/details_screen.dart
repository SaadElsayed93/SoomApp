import 'package:flutter/material.dart';
import '../models/fasting_day.dart';
import '../services/fasting_calculator.dart';

class DetailsScreen extends StatelessWidget {
  final FastingDay day;
  const DetailsScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(day.nameAr)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📅 هجري: ${day.hijriDate}", style: const TextStyle(fontSize: 18)),
            Text("📅 ميلادي: ${day.gregorianDate}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text(
              day.type == FastingType.recommended
                  ? "✅ هذا اليوم مستحب صيامه"
                  : "⛔️ لا يُسن الصيام في هذا اليوم",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "📖 الحديث الشريف: (تقدر تربط API لاحقًا)",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
