import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/fasting_day.dart';

class FastingDayService {
  Future<List<FastingDay>> loadDays() async {
    final String response = await rootBundle.loadString('assets/data/fasting_days.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => FastingDay.fromJson(e)).toList();
  }
}
