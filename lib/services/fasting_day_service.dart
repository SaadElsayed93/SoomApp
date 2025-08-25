import 'package:flutter/material.dart';
import '../models/fasting_day.dart';

class FastingDayService {
  /// دالة ترجع نوع اليوم (مستحب / منهي / عادي)
  static FastingType classifyDay(DateTime date) {
    // الاثنين والخميس مستحب
    if (date.weekday == DateTime.monday || date.weekday == DateTime.thursday) {
      return FastingType.recommended;
    }

    // الجمعة منفردة منهي عنها
    if (date.weekday == DateTime.friday) {
      return FastingType.forbidden;
    }

    // TODO: تقدر تضيف هنا الأيام الخاصة زي عاشوراء، عرفة، الأيام البيض... الخ
    // مثال:
    // if (isArafa(date)) return FastingType.recommended;

    return FastingType.normal;
  }

  /// دالة تجيب الأسبوع كله (من الاثنين → الأحد مثلاً)
  static List<FastingDay> getWeekDays(DateTime start) {
    return List.generate(7, (i) {
      final date = start.add(Duration(days: i));
      return FastingDay(date: date, type: classifyDay(date));
    });
  }

  /// مثال لدالة تحدد يوم عرفة
  static bool isArafa(DateTime date) {
    // يوم 9 ذو الحجة (مش متحقق 100% بدون مكتبة هجري دقيقة)
    return date.day == 9 && date.month == 6; // مؤقت بس
  }
}
