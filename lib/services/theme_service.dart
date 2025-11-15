import 'package:flutter/material.dart';
import '../models/setting_model.dart';

class ThemeService extends ChangeNotifier {
  SettingModel _settings = defaultSettings;

  SettingModel get settings => _settings;

  bool get isDarkMode => _settings.darkMode;

  void updateDarkMode(bool value) {
    _settings = _settings.copyWith(darkMode: value);
    notifyListeners(); // يخبر الـ UI بتحديث الثيم
  }

  void updateLanguage(String value) {
    _settings = _settings.copyWith(language: value);
    notifyListeners();
  }

  void updateCameraQuality(double value) {
    _settings = _settings.copyWith(cameraQuality: value);
    notifyListeners();
  }

  void updateLoginType(String value) {
    _settings = _settings.copyWith(loginType: value);
    notifyListeners();
  }
}
