import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home_screen.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
