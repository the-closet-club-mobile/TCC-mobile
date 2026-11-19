import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color sand = Color(0xFFD9C7AF);
  static const Color ink = Color(0xFF292923);
  static const Color cream = Color(0xFFF8F3E9);
  static const Color forest = Color(0xFF344536);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.forest,
        onPrimary: AppColors.cream,
        secondary: AppColors.sand,
        onSecondary: AppColors.ink,
        surface: AppColors.cream,
        onSurface: AppColors.ink,
      ),
      scaffoldBackgroundColor: AppColors.cream,
    );

    // Work Sans for body text, Gloock for headings.
    final body = GoogleFonts.workSansTextTheme(base.textTheme)
        .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink);
    final textTheme = body.copyWith(
      headlineLarge: GoogleFonts.gloock(textStyle: body.headlineLarge),
      headlineMedium: GoogleFonts.gloock(textStyle: body.headlineMedium),
      headlineSmall: GoogleFonts.gloock(textStyle: body.headlineSmall),
      titleLarge: GoogleFonts.gloock(textStyle: body.titleLarge),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.forest,
        foregroundColor: AppColors.cream,
        titleTextStyle: GoogleFonts.gloock(
          fontSize: 22,
          color: AppColors.cream,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cream,
        indicatorColor: AppColors.sand,
      ),
    );
  }
}