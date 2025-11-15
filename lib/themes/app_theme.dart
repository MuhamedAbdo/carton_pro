import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6200EE),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF03DAC6),
        onSecondary: Color(0xFF000000),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF000000),
        error: Color(0xFFB00020),
        onError: Color(0xFFFFFFFF),
      ),
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6200EE),
        foregroundColor: Color(0xFFFFFFFF),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
      ),
      // Drawer theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFFFFFFFF),
      ),
      // Card theme
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // ExpansionTile theme
      expansionTileTheme: const ExpansionTileThemeData(
        iconColor: Color(0xFF6200EE),
        collapsedIconColor: Color(0xFF6200EE),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFBB86FC),
        onPrimary: Color(0xFF000000),
        secondary: Color(0xFF03DAC6),
        onSecondary: Color(0xFF000000),
        surface: Color(0xFF121212),
        onSurface: Color(0xFFFFFFFF),
        error: Color(0xFFCF6679),
        onError: Color(0xFF000000),
      ),
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Color(0xFFFFFFFF),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
      ),
      // Drawer theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF121212),
      ),
      // Card theme
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // ExpansionTile theme
      expansionTileTheme: const ExpansionTileThemeData(
        iconColor: Color(0xFFBB86FC),
        collapsedIconColor: Color(0xFFBB86FC),
      ),
    );
  }
}
