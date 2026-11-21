import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App typography helper supporting Playfair Display for headings,
/// Manrope for English body, and Noto Sans Gujarati for Gujarati text.
class AppTypography {
  AppTypography._();

  // Heading Font: Playfair Display
  static TextStyle heading({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w700,
    Color color = AppColors.textPrimary,
    double letterSpacing = -0.5,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // Gujarati Font: Noto Sans Gujarati
  static TextStyle gujarati({
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.textPrimary,
    double height = 1.35,
  }) {
    return GoogleFonts.notoSansGujarati(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  // English Body Font: Manrope
  static TextStyle manrope({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double height = 1.4,
    double letterSpacing = 0.1,
  }) {
    return GoogleFonts.manrope(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Dynamic text that applies Noto Sans Gujarati if text contains Gujarati characters, else Manrope
  static TextStyle dynamicBody(
    String text, {
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double? height,
  }) {
    final bool hasGujarati = text.codeUnits.any((code) => code >= 0x0A80 && code <= 0x0AFF);
    if (hasGujarati) {
      return gujarati(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height ?? 1.35,
      );
    }
    return manrope(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height ?? 1.4,
    );
  }
}
