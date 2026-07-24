import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_palettes.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => pastelTheme;

  static ThemeData get darkTheme {
    final p = AppPalettes.darkPalette;
    return _buildTheme(p);
  }

  static ThemeData get pastelTheme {
    final p = AppPalettes.pastelPalette;
    return _buildTheme(p);
  }

  static ThemeData _buildTheme(dynamic p) {
    final isDark = p.background == AppPalettes.darkPalette.background;
    final brightness = isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: p.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: p.gold,
        onPrimary: p.background,
        secondary: p.goldLight,
        onSecondary: p.background,
        surface: p.surface,
        onSurface: p.textPrimary,
        error: p.error,
        onError: p.background,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ).apply(
        bodyColor: p.textPrimary,
        displayColor: p.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: p.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.gold,
          foregroundColor: p.background,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
          elevation: 8,
          shadowColor: p.gold.withValues(alpha: 0.25),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.backgroundElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.gold.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.gold.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: p.gold.withValues(alpha: 0.7),
          letterSpacing: 1.5,
        ),
        hintStyle: GoogleFonts.dmSans(
          fontSize: 14,
          color: p.textHint,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.gold,
        foregroundColor: p.background,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
