import 'package:carton_pro/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/setting_model.dart';
import '../models/ink_report_model.dart'; // ✅ استيراد InkReport

class AppService {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();

    // ✅ تسجيل الـ adapter
    Hive.registerAdapter(SettingModelAdapter());
    Hive.registerAdapter(InkReportAdapter()); // ✅ تسجيل InkReport

    // ✅ فتح الـ box
    await Hive.openBox<SettingModel>('settings_box');
    await Hive.openBox<InkReport>('inkReports'); // ✅ فتح inkReports box

    // ✅ إزالة هذا السطر لأنه مكرر
    // await Hive.openBox<SettingModel>('settings_box');
  }

  static Future<ThemeService> initializeThemeService() async {
    final themeService = ThemeService();
    await themeService.init();
    return themeService;
  }
}
