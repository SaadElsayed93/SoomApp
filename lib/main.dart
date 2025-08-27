import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fasting_reminder/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  runApp(const FastingApp());
}

class FastingApp extends StatelessWidget {
  const FastingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "تطبيق الصيام",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo', // لو حابب الخط يكون عربي جميل
      ),
      home: const MainScreen(), // ✅ هنا خلي البداية على MainScreen
    );
  }
}
