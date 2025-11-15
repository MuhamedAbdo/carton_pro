import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
// import '../screens/login_screen.dart'; // هنضيفه لاحقًا
// import '../screens/about_me_screen.dart'; // هنضيفه لاحقًا
// import '../screens/privacy_policy_screen.dart'; // هنضيفه لاحقًا

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
    // GoRoute(
    //   path: '/login',
    //   name: 'login',
    //   builder: (context, state) => const LoginScreen(),
    // ),
    // GoRoute(
    //   path: '/about',
    //   name: 'about',
    //   builder: (context, state) => const AboutMeScreen(),
    // ),
    // GoRoute(
    //   path: '/privacy',
    //   name: 'privacy',
    //   builder: (context, state) => const PrivacyPolicyScreen(),
    // ),
  ],
);
