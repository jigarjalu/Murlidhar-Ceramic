import 'package:flutter/material.dart';

/// App color system matching the reference design and specifications.
class AppColors {
  AppColors._();

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0B0B0C);
  static const Color darkSurface = Color(0xFF141416);
  static const Color darkCard = Color(0xFF1A1A1E);
  static const Color darkCardBorder = Color(0x33D9A441);
  static const Color darkTextPrimary = Color(0xFFF5F3EF);
  static const Color darkTextSecondary = Color(0xFFA59E92);

  // Light / Cream Theme Colors
  static const Color creamBackground = Color(0xFFF6EFE4);
  static const Color creamCard = Color(0xFFFFFBF4);
  static const Color creamCardBorder = Color(0x221B1712);
  static const Color textPrimary = Color(0xFF1B1712);
  static const Color textSecondary = Color(0xFF6B6254);
  static const Color textMuted = Color(0xFF9E9589);

  // Gold Accents & Gradients
  static const Color goldStart = Color(0xFFD9A441);
  static const Color goldEnd = Color(0xFFF2CE7A);
  static const Color goldAccent = Color(0xFFE5B95C);
  static const Color goldDark = Color(0xFFB38226);
  static const Color goldLight = Color(0xFFF9E8B8);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldStart, goldEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient goldGradientVertical = LinearGradient(
    colors: [goldStart, goldEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Button text colors
  static const Color goldButtonText = Color(0xFF1B1208);
  static const Color darkButtonBackground = Color(0xFF1B1712);

  // Status Chips
  static const Color statusPending = Color(0xFFF59E0B); // Orange Pending
  static const Color statusPendingBg = Color(0x26F59E0B);
  static const Color statusContacted = Color(0xFF10B981); // Green Contacted
  static const Color statusContactedBg = Color(0x2610B981);
  static const Color statusClosed = Color(0xFF6B7280); // Grey Closed
  static const Color statusClosedBg = Color(0x266B7280);

  // Functional Colors
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color favoriteRed = Color(0xFFE53935);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color starGold = Color(0xFFFFB300);

  // Shimmer Colors
  static const Color darkShimmerBase = Color(0xFF1A1A1E);
  static const Color darkShimmerHighlight = Color(0xFF2C2C34);
  static const Color lightShimmerBase = Color(0xFFEADECA);
  static const Color lightShimmerHighlight = Color(0xFFFDFCFA);
}
