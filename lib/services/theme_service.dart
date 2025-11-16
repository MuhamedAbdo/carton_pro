import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/setting_model.dart';

class ThemeService extends ChangeNotifier {
  static const String _settingsBoxName = 'settings_box';
  static const String _settingsKey = 'settings_key';

  SettingModel _settings = defaultSettings;

  SettingModel get settings => _settings;

  bool get isDarkMode => _settings.darkMode;

  // تهيئة الـ service
  Future<void> init() async {
    await _openBox();
    _loadSettings();
  }

  Future<void> _openBox() async {
    if (!Hive.isBoxOpen(_settingsBoxName)) {
      await Hive.openBox<SettingModel>(_settingsBoxName);
    }
  }

  void _loadSettings() {
    final box = Hive.box<SettingModel>(_settingsBoxName);
    final savedSettings = box.get(_settingsKey);
    if (savedSettings != null) {
      _settings = savedSettings;
    } else {
      // إذا مكنش في إعدادات محفوظة، استخدم الإعدادات الافتراضية واحفظها
      _settings = defaultSettings;
      _saveSettings();
    }
  }

  void _saveSettings() {
    final box = Hive.box<SettingModel>(_settingsBoxName);
    box.put(_settingsKey, _settings);
  }

  void updateDarkMode(bool value) {
    _settings = _settings.copyWith(darkMode: value);
    _saveSettings(); // حفظ التغيير
    notifyListeners();
  }

  void updateLanguage(String value) {
    _settings = _settings.copyWith(language: value);
    _saveSettings(); // حفظ التغيير
    notifyListeners();
  }

  void updateCameraQuality(double value) {
    _settings = _settings.copyWith(cameraQuality: value);
    _saveSettings(); // حفظ التغيير
    notifyListeners();
  }

  void updateLoginType(String value) {
    _settings = _settings.copyWith(loginType: value);
    _saveSettings(); // حفظ التغيير
    notifyListeners();
  }
}
