import 'package:flutter/material.dart';

class AppColors {
  // 🎨 الألوان الأساسية للتطبيق
  static const primary = Color.fromARGB(255, 138, 138, 138);
  static const textDark = Color(0xFF333333);
  static const textLight = Color(0xFF757575); // رمادي غامق شوية للنصوص الثانوية

  // 🎨 ألوان الصيام
  static const obligatoryFasting = Color(0xFF4CAF50); // أخضر - واجب
  static const recommendedFasting = Color(0xFF2196F3); // أزرق - مستحب
  static const forbiddenFasting = Color(0xFFE53935); // أحمر - منهي
  static const normalDay = Color(0xFFE0E0E0); // رمادي فاتح - عادي

  // 🎨 ألوان إضافية
  static const highlightDay = Color(0xFFFFF3E0); // برتقالي فاتح - اليوم الحالي
  static const selectedDay = Color(0xFFD1C4E9); // بنفسجي فاتح - يوم مختار
}
