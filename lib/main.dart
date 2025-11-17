// lib/main.dart
import 'package:carton_pro/my_app.dart';
import 'package:carton_pro/services/app_service.dart';
import 'package:carton_pro/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // تهيئة مبكرة
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive وفتح الـ boxes
  await AppService.initializeApp();

  // تهيئة ThemeService (يقرأ الإعدادات من Hive داخليًا)
  final themeService = await AppService.initializeThemeService();

  // شغّل التطبيق بعد التهيئة مباشرة
  runApp(
    ChangeNotifierProvider<ThemeService>.value(
      value: themeService,
      child: const MyApp(),
    ),
  );
}
