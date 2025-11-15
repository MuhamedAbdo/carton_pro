import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('الإعدادات'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Theme Section
              Card(
                child: ExpansionTile(
                  title: const Text('المظهر'),
                  leading: const Icon(Icons.brightness_6),
                  children: [
                    SwitchListTile(
                      title: const Text('الوضع الليلي'),
                      value: themeService
                          .isDarkMode, // استخدم القيمة من ThemeService
                      onChanged: (bool value) {
                        themeService.updateDarkMode(
                            value); // حدث القيمة في ThemeService
                      },
                    ),
                  ],
                ),
              ),

              // Language Section
              Card(
                child: ExpansionTile(
                  title: const Text('اللغة'),
                  leading: const Icon(Icons.language),
                  children: [
                    RadioListTile<String>(
                      title: const Text('العربية'),
                      value: 'ar',
                      groupValue: themeService
                          .settings.language, // استخدم القيمة من ThemeService
                      onChanged: (String? value) {
                        if (value != null) {
                          themeService.updateLanguage(
                              value); // حدث القيمة في ThemeService
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('الإنجليزية'),
                      value: 'en',
                      groupValue: themeService
                          .settings.language, // استخدم القيمة من ThemeService
                      onChanged: (String? value) {
                        if (value != null) {
                          themeService.updateLanguage(
                              value); // حدث القيمة في ThemeService
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Camera Quality Section
              Card(
                child: ExpansionTile(
                  title: const Text('جودة الكاميرا'),
                  leading: const Icon(Icons.camera_alt),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Text('منخفضة'),
                          Expanded(
                            child: Slider(
                              value: themeService.settings
                                  .cameraQuality, // استخدم القيمة من ThemeService
                              min: 0.1,
                              max: 1.0,
                              divisions: 9,
                              label:
                                  '${(themeService.settings.cameraQuality * 100).round()}%',
                              onChanged: (double value) {
                                themeService.updateCameraQuality(
                                    value); // حدث القيمة في ThemeService
                              },
                            ),
                          ),
                          const Text('عالية'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Login Type Section
              Card(
                child: ExpansionTile(
                  title: const Text('نوع الدخول'),
                  leading: const Icon(Icons.login),
                  children: [
                    RadioListTile<String>(
                      title: const Text('مميز (مع حساب)'),
                      value: 'authenticated',
                      groupValue: themeService
                          .settings.loginType, // استخدم القيمة من ThemeService
                      onChanged: (String? value) {
                        if (value != null) {
                          themeService.updateLoginType(
                              value); // حدث القيمة في ThemeService
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('ضيف (بدون حساب)'),
                      value: 'guest',
                      groupValue: themeService
                          .settings.loginType, // استخدم القيمة من ThemeService
                      onChanged: (String? value) {
                        if (value != null) {
                          themeService.updateLoginType(
                              value); // حدث القيمة في ThemeService
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Backup Section
              Card(
                child: ExpansionTile(
                  title: const Text('النسخ الاحتياطي'),
                  leading: const Icon(Icons.backup),
                  children: [
                    ListTile(
                      title: const Text('حفظ النسخة الاحتياطية'),
                      leading: const Icon(Icons.save),
                      onTap: () {
                        // TODO: Implement backup save
                      },
                    ),
                    ListTile(
                      title: const Text('استعادة النسخة الاحتياطية'),
                      leading: const Icon(Icons.restore),
                      onTap: () {
                        // TODO: Implement backup restore
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
