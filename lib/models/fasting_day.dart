import '../services/fasting_calculator.dart';

class FastingDay {
  final DateTime date;
  final String nameAr;
  final String hijriDate;
  final String gregorianDate;
  final FastingType type;

  FastingDay({
    required this.date,
    required this.nameAr,
    required this.hijriDate,
    required this.gregorianDate,
    required this.type,
  });
}
