import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/color_detail_screen.dart'; // ✅ استيراد الشاشة
import '../screens/color_palette_screen.dart';
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
      path: '/flexo',
      name: 'flexo',
      builder: (context, state) => const FlexoScreen(),
    ),
    GoRoute(
      path: '/color_palette',
      name: 'color_palette',
      builder: (context, state) => const ColorPaletteScreen(),
    ),
    GoRoute(
      // ✅ إضافة Color Detail Screen
      path: '/color_detail',
      name: 'color_detail',
      builder: (context, state) {
        final color = state.extra as CMYK;
        return ColorDetailScreen(originalCmyk: color);
      },
    ),
  ],
);
