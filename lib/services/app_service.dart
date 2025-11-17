// lib/services/app_service.dart
import 'package:carton_pro/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/setting_model.dart';
import '../models/ink_report_model.dart'; // ✅ استيراد InkReport
import '../models/store_entry_model.dart'; // ✅ استيراد StoreEntry
import '../models/maintenance_record.dart'; // ✅ استيراد MaintenanceRecord
import '../models/worker_model.dart'; // ✅ استيراد Worker
import '../models/worker_action_model.dart'; // ✅ استيراد WorkerAction

class AppService {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();

    // ✅ تسجيل الـ adapter
    Hive.registerAdapter(SettingModelAdapter());
    Hive.registerAdapter(InkReportAdapter()); // ✅ تسجيل InkReport
    Hive.registerAdapter(StoreEntryAdapter()); // ✅ تسجيل StoreEntry
    Hive.registerAdapter(
        MaintenanceRecordAdapter()); // ✅ تسجيل MaintenanceRecord
    Hive.registerAdapter(WorkerAdapter()); // ✅ تسجيل Worker
    Hive.registerAdapter(WorkerActionAdapter()); // ✅ تسجيل WorkerAction

    // ✅ فتح الـ box
    await Hive.openBox<SettingModel>('settings_box');
    await Hive.openBox<InkReport>('inkReports'); // ✅ فتح inkReports box
    await Hive.openBox<StoreEntry>('storeEntries'); // ✅ فتح storeEntries box
    await Hive.openBox<MaintenanceRecord>(
        'maintenanceRecords'); // ✅ فتح maintenanceRecords box
    await Hive.openBox<WorkerAction>(
        'worker_actions'); // ✅ فتح worker_actions box أولاً
    await Hive.openBox<Worker>('workers'); // ✅ فتح workers box

    // ✅ تأكد من أن worker_actions box مفتوح قبل استخدام Worker
    final workersBox = Hive.box<Worker>('workers');
    for (var worker in workersBox.values) {
      worker.reconnectActionsBox(); // ✅ ربط HiveList بالـ box
    }
  }

  static Future<ThemeService> initializeThemeService() async {
    final themeService = ThemeService();
    await themeService.init();
    return themeService;
  }
}

class HiveService {
  static Future<void> registerAdapters() async {
    // Will be implemented later
  }
}
