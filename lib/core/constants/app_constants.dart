import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52E8);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color background = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color outline = Colors.grey;
  static const Color backgroundDark = Color(0xFF121212);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<Color> chartColors = [
    Color(0xFF6C63FF),
    Color(0xFF03DAC6),
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
  ];
}

class AppSizes {
  static const double paddingXS = 2.0;
  static const double paddingS = 4.0;
  static const double paddingM = 6.0;
  static const double paddingL = 12.0;
  static const double paddingXL = 16.0;

  static const double radiusS = 4.0;
  static const double radiusM = 6.0;
  static const double radiusL = 8.0;
  static const double radiusXL = 12.0;

  static const double iconS = 8.0;
  static const double iconM = 12.0;
  static const double iconL = 16.0;
  static const double iconXL = 24.0;
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration staggerDelay = Duration(milliseconds: 100);
}
