import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock values for settings
  bool _darkMode = false;
  String _language = 'ar';
  double _cameraQuality = 1.0; // 1.0 = highest, 0.1 = lowest

  @override
  Widget build(BuildContext context) {
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
                  value: _darkMode,
                  onChanged: (bool value) {
                    setState(() {
                      _darkMode = value;
                    });
                    // TODO: Apply theme change
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
                  groupValue: _language,
                  onChanged: (String? value) {
                    setState(() {
                      _language = value!;
                    });
                    // TODO: Apply language change
                  },
                ),
                RadioListTile<String>(
                  title: const Text('الإنجليزية'),
                  value: 'en',
                  groupValue: _language,
                  onChanged: (String? value) {
                    setState(() {
                      _language = value!;
                    });
                    // TODO: Apply language change
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
                          value: _cameraQuality,
                          min: 0.1,
                          max: 1.0,
                          divisions: 9,
                          label: '${(_cameraQuality * 100).round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _cameraQuality = value;
                            });
                            // TODO: Apply camera quality setting
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
                  groupValue: 'guest', // Mock value for now
                  onChanged: (String? value) {
                    // TODO: Implement login type change
                  },
                ),
                RadioListTile<String>(
                  title: const Text('ضيف (بدون حساب)'),
                  value: 'guest',
                  groupValue: 'guest',
                  onChanged: (String? value) {
                    // TODO: Implement login type change
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
  }
}
