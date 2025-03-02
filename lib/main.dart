import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'utils/theme.dart';

void main() {
  runApp(const StudentHelperApp());
}

class StudentHelperApp extends StatelessWidget {
  const StudentHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Helper',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}