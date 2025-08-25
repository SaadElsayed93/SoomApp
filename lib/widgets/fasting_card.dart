import 'package:flutter/material.dart';
import '../models/fasting_day.dart';
import '../services/fasting_calculator.dart';

class FastingCard extends StatelessWidget {
  final FastingDay day;
  final VoidCallback onTap;

  const FastingCard({super.key, required this.day, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (day.type == FastingType.recommended) {
      color = Colors.green.shade100;
    } else if (day.type == FastingType.forbidden) {
      color = Colors.red.shade100;
    } else {
      color = Colors.grey.shade200;
    }

    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(day.nameAr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("هجري: ${day.hijriDate} \nميلادي: ${day.gregorianDate}"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
