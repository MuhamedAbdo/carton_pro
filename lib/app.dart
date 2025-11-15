import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart';
import 'screens/splash_screen.dart';
import 'services/app_service.dart';
import 'services/theme_service.dart';
import 'themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeService>(
      future: AppService.initializeThemeService(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen(); // أظهر الـ Splash Screen
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        } else {
          final themeService = snapshot.data!;
          return ChangeNotifierProvider.value(
            value: themeService,
            child: Consumer<ThemeService>(
              builder: (context, themeService, child) {
                return MaterialApp.router(
                  title: 'CartonPro',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeService.isDarkMode
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  routerConfig: appRouter,
                );
              },
            ),
          );
        }
      },
    );
  }
}
