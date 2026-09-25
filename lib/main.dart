import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_try_0/theme/app_theme.dart';
import 'package:flutter_application_try_0/screens/dashboard_screen.dart';
import 'package:flutter_application_try_0/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (!kIsWeb) {
    try {
      // Initialize database
      final dbHelper = DatabaseHelper();
      await dbHelper.database; // This triggers database creation
    } catch (e) {
      debugPrint('Database initialization warning: $e');
    }
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AJ Fitness Gym',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}