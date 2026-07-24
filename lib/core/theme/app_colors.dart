import 'package:flutter/material.dart';
import 'palette_provider.dart';
import 'color_palette.dart';

class AppColors {
  AppColors._();

  static ColorPalette of(BuildContext context) {
    return PaletteProvider.of(context);
  }

  static const Color background = Color(0xFF080808);
  static const Color backgroundElevated = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF111111);
  static const Color surfaceLight = Color(0xFF1B1B1B);

  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3D076);
  static const Color goldDark = Color(0xFFB8860B);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textMuted = Color(0xFF888888);
  static const Color textHint = Color(0xFF666666);

  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFECA57);

  static const Color primary = gold;
  static const Color primaryLight = goldLight;
  static const Color primaryDark = goldDark;
  static const Color secondary = goldLight;
}
