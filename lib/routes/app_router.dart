import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/flexo_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // الصفحة الافتراضية
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      // ✅ إضافة Flexo Screen
      path: '/flexo',
      name: 'flexo',
      builder: (context, state) => const FlexoScreen(),
    ),
  ],
);
