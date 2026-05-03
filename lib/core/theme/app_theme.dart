import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => _build(isDark: true);
  static ThemeData get light => _build(isDark: false);

  static ThemeData _build({required bool isDark}) {
    final bg       = isDark ? AppColors.darkBg       : AppColors.lightBg;
    final surface  = isDark ? AppColors.darkSurface  : AppColors.lightSurface;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final text     = isDark ? AppColors.darkText      : AppColors.lightText;
    final textDim  = isDark ? AppColors.darkTextDim   : AppColors.lightTextDim;
    final lime     = isDark ? AppColors.darkLime      : AppColors.lightLime;
    final border   = isDark ? AppColors.darkBorder    : AppColors.lightBorder;

    final baseText = GoogleFonts.notoSansKr(color: text);

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: lime,
        onPrimary: isDark ? AppColors.darkBg : AppColors.lightBg,
        secondary: isDark ? AppColors.darkAmber : AppColors.lightAmber,
        onSecondary: isDark ? AppColors.darkBg : AppColors.lightBg,
        error: isDark ? AppColors.darkRose : AppColors.lightRose,
        onError: Colors.white,
        surface: surface,
        onSurface: text,
      ),
      textTheme: TextTheme(
        // H1: 24/800
        headlineLarge: baseText.copyWith(
          fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5,
        ),
        // H2: 20/700
        headlineMedium: baseText.copyWith(
          fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3,
        ),
        // Body large: 20/600/1.5
        bodyLarge: baseText.copyWith(
          fontSize: 20, fontWeight: FontWeight.w600, height: 1.5,
        ),
        // Body: 16/500
        bodyMedium: baseText.copyWith(
          fontSize: 16, fontWeight: FontWeight.w500,
        ),
        // Caption: 13/500
        bodySmall: baseText.copyWith(
          fontSize: 13, fontWeight: FontWeight.w500, color: textDim,
        ),
        // Label small: 11/700 uppercase mono
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 11, fontWeight: FontWeight.w700,
          letterSpacing: 1.0, color: textDim,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.notoSansKr(
          fontSize: 18, fontWeight: FontWeight.w700, color: text,
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface2,
        hintStyle: baseText.copyWith(color: textDim, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      useMaterial3: true,
    );
  }
}
