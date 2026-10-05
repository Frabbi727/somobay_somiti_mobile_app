import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors (Cooperative Trust Green & Rich Teal)
  static const Color primary = Color(0xFF1B5E20);       // Forest Green
  static const Color primaryDark = Color(0xFF003300);
  static const Color primaryLight = Color(0xFF4C8C4A);
  static const Color primaryContainer = Color(0xFFE8F5E9);

  // Secondary Accent Colors
  static const Color secondary = Color(0xFF00897B);     // Emerald Teal
  static const Color secondaryDark = Color(0xFF005B4F);
  static const Color secondaryLight = Color(0xFF4EBAAA);
  static const Color secondaryContainer = Color(0xFFE0F2F1);

  // Financial States
  static const Color deposit = Color(0xFF2E7D32);       // Credit / Inflow
  static const Color withdraw = Color(0xFFC62828);      // Debit / Outflow
  static const Color overdue = Color(0xFFE65100);       // Late fine / Overdue
  static const Color pending = Color(0xFFF57F17);       // Pending status

  // Neutral & Surfaces (Light)
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFCCCCCC);

  // Neutral & Surfaces (Dark)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFA0A0A0);
  static const Color dividerDark = Color(0xFF333333);
  static const Color borderDark = Color(0xFF444444);

  // Status & Alerts
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF1976D2);
}
