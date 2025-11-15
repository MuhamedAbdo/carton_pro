import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/setting_model.dart';
import 'theme_service.dart';

class AppService {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();

    // تسجيل الـ adapter
    Hive.registerAdapter(SettingModelAdapter());

    // فتح الـ box
    await Hive.openBox<SettingModel>('settings_box');
  }

  static Future<ThemeService> initializeThemeService() async {
    final themeService = ThemeService();
    await themeService.init();
    return themeService;
  }
}
