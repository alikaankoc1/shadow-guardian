import 'package:flutter/material.dart';

abstract final class AppColors {
  static const sky = Color(0xFFE3F2FD);
  static const skyDeep = Color(0xFFBDE6F7);
  static const navy = Color(0xFF294C60);
  static const slate = Color(0xFF5E7A89);
  static const coral = Color(0xFFFF7A68);
  static const coralDark = Color(0xFFE85F50);
  static const sunshine = Color(0xFFFFC857);
  static const mint = Color(0xFF66CDAA);
  static const blue = Color(0xFF45A9E6);
  static const white = Color(0xFFFFFFFF);
  static const shadow = Color(0xFF344955);
  static const locked = Color(0xFFB0BEC5);
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.coral,
      brightness: Brightness.light,
      primary: AppColors.coral,
      secondary: AppColors.blue,
      surface: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Nunito',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.sky,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          decoration: TextDecoration.none,
          color: AppColors.navy,
          fontSize: 44,
          fontWeight: FontWeight.w900,
          height: 1.05,
        ),
        headlineLarge: TextStyle(
          decoration: TextDecoration.none,
          color: AppColors.navy,
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),
        titleLarge: TextStyle(
          decoration: TextDecoration.none,
          color: AppColors.navy,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          decoration: TextDecoration.none,
          color: AppColors.slate,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.coral,
          foregroundColor: AppColors.white,
          minimumSize: const Size(200, 58),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          elevation: 0,
          textStyle: const TextStyle(
            decoration: TextDecoration.none,
            fontFamily: 'Nunito',
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }
}
