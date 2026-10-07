import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const navy      = Color(0xFF0B1F3A);
  static const gold      = Color(0xFFC9952A);
  static const goldLight = Color(0xFFF5D98B);
  static const cream     = Color(0xFFFAF7F2);
  static const border    = Color(0xFFE5E2DC);
  static const muted     = Color(0xFF6B7280);
  static const green     = Color(0xFF16A34A);
  static const red       = Color(0xFFDC2626);
  static const white     = Colors.white;
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      primary: AppColors.navy,
      secondary: AppColors.gold,
      surface: AppColors.white,
    ),
    textTheme: GoogleFonts.dmSansTextTheme().copyWith(
      displayLarge:  GoogleFonts.playfairDisplay(fontWeight: FontWeight.w900, color: AppColors.navy),
      displayMedium: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: AppColors.navy),
      headlineLarge: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: AppColors.navy),
      headlineMedium:GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: AppColors.navy),
      titleLarge:    GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: AppColors.navy),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.navy,
      foregroundColor: AppColors.gold,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.gold),
      iconTheme: const IconThemeData(color: AppColors.gold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.gold,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w500, fontSize: 15),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cream,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    ),
    cardTheme: CardTheme(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      margin: const EdgeInsets.only(bottom: 12),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.navy,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: Color(0x55FFFFFF),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 10),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, space: 1),
  );
}
