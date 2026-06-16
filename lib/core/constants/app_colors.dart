import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const Color backgroundDark = Color(0xFF1A1D24);
  static const Color surfaceDark = Color(0xFF22262E);
  static const Color surfaceElevatedDark = Color(0xFF272B34);

  // Accent - Teal/Emerald (income, positive, CTA)
  static const Color accent = Color(0xFF2DD4BF);
  static const Color accentSecondary = Color(0xFF10B981);

  // Negative - Coral (expense, warning)
  static const Color negative = Color(0xFFF87171);
  static const Color negativeSecondary = Color(0xFFFB7185);

  // Neutral text
  static const Color textPrimary = Color(0xFFE8ECF0);
  static const Color textSecondary = Color(0xFF8892A0);
  static const Color textDisabled = Color(0xFF4A5260);

  // Dividers
  static const Color divider = Color(0xFF2E3440);

  // Neumorphic shadows
  static const Color shadowDark = Color(0xFF13161C);
  static const Color shadowLight = Color(0xFF2B3040);

  // Status colors
  static const Color success = Color(0xFF2DD4BF);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFF87171);

  // Category colors
  static const List<Color> categoryPalette = [
    Color(0xFF2DD4BF),
    Color(0xFF818CF8),
    Color(0xFFFB7185),
    Color(0xFFFBBF24),
    Color(0xFF34D399),
    Color(0xFF60A5FA),
    Color(0xFFF472B6),
    Color(0xFFa78BFA),
  ];
}
