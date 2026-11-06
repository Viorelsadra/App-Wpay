import 'package:flutter/material.dart';

class AppColor {
  static const Color primary = Color(0xFF2D7A5B);
  static const Color secondary = Color(0xFF38D186);
  static const Color accent = Color(0xFFFBB040);
  
  static const Color cardDark = Color(0xFF00383C);
  static const Color inputBackground = Color(0xFFF1F4FF);
  static const Color socialButtonBg = Color(0xFFECECEC);
  static const Color brandStarbucks = Color(0xFF006241);
  
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.grey;
  static const Color textLight = Colors.white;
  static const Color textFaded = Colors.white70;

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF38D186),
      Color(0xFF2D7A5B),
    ],
  );
}