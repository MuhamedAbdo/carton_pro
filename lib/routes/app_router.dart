import 'package:go_router/go_router.dart';
import '../screens/camera_color_picker_screen.dart';
import '../screens/color_detail_screen.dart';
import '../screens/color_palette_screen.dart';
import '../screens/flexo_screen.dart';
import '../screens/home_screen.dart';
import '../screens/ink_report_screen.dart'; // ✅ استيراد الشاشة
import '../screens/manual_mix_screen.dart';
import '../screens/serial_setup_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart'; // استيراد splash
import '../screens/store_entry_screen.dart'; // ✅ استيراد شاشة وارد المخزن

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash', // ✅ غير إلى splash
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) =>
          const SplashScreen(), // ✅ Route جديد لـ splash
    ),
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
      path: '/color_detail',
      name: 'color_detail',
      builder: (context, state) {
        final color = state.extra as CMYK;
        return ColorDetailScreen(originalCmyk: color);
      },
    ),
    GoRoute(
      path: '/manual_mix',
      name: 'manual_mix',
      builder: (context, state) => const ManualMixScreen(),
    ),
    GoRoute(
      path: '/camera_color_picker',
      name: 'camera_color_picker',
      builder: (context, state) => const CameraColorPickerScreen(),
    ),
    GoRoute(
      path: '/serial_setup',
      name: 'serial_setup',
      builder: (context, state) => const SerialSetupScreen(),
    ),
    GoRoute(
      // ✅ إضافة Ink Report Screen
      path: '/ink_report',
      name: 'ink_report',
      builder: (context, state) => const InkReportScreen(),
    ),
    // ✅ إضافة Store Entry Screen
    GoRoute(
      path: '/store_entry',
      name: 'store_entry',
      builder: (context, state) => const StoreEntryScreen(),
    ),
  ],
);
