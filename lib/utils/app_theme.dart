import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color lightBgStart = Color(0xFFFFF8F0);
  static const Color lightBgEnd = Color(0xFFFFE4C4);
  static const Color lightPrimary = Color(0xFFFF6B35);
  static const Color lightPrimaryVariant = Color(0xFFFF8C42);
  static const Color lightQuoteText = Color(0xFF2D2D2D);
  static const Color lightCardColor = Colors.white;
  static const Color lightSurface = Colors.white;

  static const Color darkBgStart = Color(0xFF1A1A2E);
  static const Color darkBgEnd = Color(0xFF16213E);
  static const Color darkPrimary = Color(0xFFE94560);
  static const Color darkPrimaryVariant = Color(0xFFC62A47);
  static const Color darkQuoteText = Color(0xFFF5F5F5);
  static const Color darkCardColor = Color(0xFF0F3460);
  static const Color darkSurface = Color(0xFF0F3460);

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightBgStart, lightBgEnd],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBgStart, darkBgEnd],
  );

  static const LinearGradient lightButtonGradient = LinearGradient(
    colors: [lightPrimary, lightPrimaryVariant],
  );

  static const LinearGradient darkButtonGradient = LinearGradient(
    colors: [darkPrimary, darkPrimaryVariant],
  );

  static const List<Color> lightAnimatedColors = [
    Color(0xFFFFF8F0),
    Color(0xFFFFE4C4),
    Color(0xFFFFD6A5),
    Color(0xFFFFF0DB),
  ];

  static const List<Color> darkAnimatedColors = [
    Color(0xFF1A1A2E),
    Color(0xFF16213E),
    Color(0xFF0F3460),
    Color(0xFF1A1A3E),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightPrimaryVariant,
        surface: lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightQuoteText,
      ),
      textTheme: _buildTextTheme(Brightness.light),
      cardTheme: CardThemeData(
        color: lightCardColor,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      iconTheme: const IconThemeData(color: lightPrimary, size: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightQuoteText,
        ),
        iconTheme: const IconThemeData(color: lightQuoteText),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkPrimaryVariant,
        surface: darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkQuoteText,
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      cardTheme: CardThemeData(
        color: darkCardColor,
        elevation: 12,
        shadowColor: darkPrimary.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      iconTheme: const IconThemeData(color: darkPrimary, size: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkQuoteText,
        ),
        iconTheme: const IconThemeData(color: darkQuoteText),
      ),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final Color textColor = isDark ? darkQuoteText : lightQuoteText;
    final Color mutedColor =
        isDark
            ? darkQuoteText.withValues(alpha: 0.7)
            : lightQuoteText.withValues(alpha: 0.6);

    return TextTheme(
      displayLarge: GoogleFonts.lora(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        color: textColor,
        height: 1.4,
      ),
      displayMedium: GoogleFonts.lora(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: textColor,
        height: 1.5,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        color: mutedColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: mutedColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: mutedColor,
      ),
    );
  }

  static LinearGradient backgroundGradient(bool isDark) {
    return isDark ? darkBackgroundGradient : lightBackgroundGradient;
  }

  static LinearGradient buttonGradient(bool isDark) {
    return isDark ? darkButtonGradient : lightButtonGradient;
  }

  static List<Color> animatedColors(bool isDark) {
    return isDark ? darkAnimatedColors : lightAnimatedColors;
  }
}
