import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF36D17C),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F1115),
    cardTheme: const CardThemeData(
      color: Color(0xFF171A20),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
    ),
  );
}
