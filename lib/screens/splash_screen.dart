// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // جدولة التنقل بعد أول إطار للتأكد من أن Build انتهى و Provider متوفر.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_navigated) return;
      _navigated = true;
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        // استبدل باسم المسار الذي تستخدمه ('home' أو '/') حسب router لديك
        context.goNamed('home'); // أو context.go('/');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // استمع لتغيرات ThemeService حتى تتغير الصورة تلقائيًا عند تبديل الثيم
    final isDarkMode = context.watch<ThemeService>().isDarkMode;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  isDarkMode
                      ? 'assets/images/logo_dark.png'
                      : 'assets/images/logo_light.png',
                ),
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'CartonPro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
