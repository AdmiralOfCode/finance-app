import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> neumorphicRaised = [
    BoxShadow(
      color: AppColors.shadowDark,
      offset: const Offset(4, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadowLight,
      offset: const Offset(-4, -4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> neumorphicPressed = [
    BoxShadow(
      color: AppColors.shadowDark,
      offset: const Offset(2, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadowLight,
      offset: const Offset(-2, -2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> neumorphicSubtle = [
    BoxShadow(
      color: AppColors.shadowDark.withValues(alpha: 0.6),
      offset: const Offset(3, 3),
      blurRadius: 8,
    ),
    BoxShadow(
      color: AppColors.shadowLight.withValues(alpha: 0.6),
      offset: const Offset(-3, -3),
      blurRadius: 8,
    ),
  ];

  static List<BoxShadow> accentGlow = [
    BoxShadow(
      color: AppColors.accent.withValues(alpha: 0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
}
