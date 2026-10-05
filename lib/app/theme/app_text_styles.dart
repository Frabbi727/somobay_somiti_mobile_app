import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get fontBase => GoogleFonts.hindSiliguri();

  // Headings
  static TextStyle get h1 => fontBase.copyWith(
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get h2 => fontBase.copyWith(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get h3 => fontBase.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  // Subtitles & Titles
  static TextStyle get titleLarge => fontBase.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => fontBase.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // Body Text
  static TextStyle get bodyLarge => fontBase.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get bodyMedium => fontBase.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get bodySmall => fontBase.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // Financial / Amount Numbers
  static TextStyle get amountLarge => fontBase.copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      );

  static TextStyle get amountMedium => fontBase.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  // Buttons & Labels
  static TextStyle get buttonText => fontBase.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get caption => fontBase.copyWith(
        fontSize: 11.0,
        fontWeight: FontWeight.normal,
        color: AppColors.textHint,
      );
}
