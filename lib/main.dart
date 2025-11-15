import 'package:carton_pro/routes/app_router.dart';
import 'package:carton_pro/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_service.dart';
import 'services/theme_service.dart';

Future<void> main() async {
  // تهيئة مبكرة
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive وفتح الـ boxes
  await AppService.initializeApp();

  // تهيئة ThemeService (يقرأ الإعدادات من Hive داخليًا)
  final themeService = await AppService.initializeThemeService();

  // شغّل التطبيق بعد التهيئة
  runApp(
    ChangeNotifierProvider<ThemeService>.value(
      value: themeService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'CartonPro',
          routerConfig: appRouter,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(themeService.settings.language),
        );
      },
    );
  }
}
