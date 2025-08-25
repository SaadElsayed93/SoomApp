import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FastingReminderApp());
}

class FastingReminderApp extends StatelessWidget {
  const FastingReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "تذكير بالصيام",
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: "Roboto",
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
