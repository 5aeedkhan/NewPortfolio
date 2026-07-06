import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized dark + neon accent theme for the portfolio.
class AppTheme {
  AppTheme._();

  // ── Core background shades ──
  static const Color bgDarkest = Color(0xFF0A0E14);
  static const Color bgDark = Color(0xFF0D1117);
  static const Color bgCard = Color(0xFF161B22);
  static const Color bgCardLight = Color(0xFF1C2333);
  static const Color bgElevated = Color(0xFF21262D);

  // ── Neon accent palette ──
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonPurple = Color(0xFFA855F7);
  static const Color neonBlue = Color(0xFF3B82F6);
  static const Color neonPink = Color(0xFFEC4899);
  static const Color neonGreen = Color(0xFF22D3EE);

  // ── Text colours ──
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);

  // ── Glassmorphism ──
  static Color glassBg = const Color(0xFF161B22).withValues(alpha: 0.6);
  static Color glassBorder = Colors.white.withValues(alpha: 0.08);
  static Color glassHighlight = Colors.white.withValues(alpha: 0.04);

  // ── Gradients ──
  static const List<Color> neonGradient = [neonCyan, neonPurple];
  static const List<Color> neonGradientFull = [neonCyan, neonBlue, neonPurple];
  static const List<Color> bgGradient = [bgDarkest, bgDark, bgCard];

  /// Linear gradient for hero / section backgrounds.
  static LinearGradient heroGradient({
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(begin: begin, end: end, colors: bgGradient);
  }

  /// Neon accent gradient (cyan → purple).
  static LinearGradient neonLinearGradient({
    Alignment begin = Alignment.centerLeft,
    Alignment end = Alignment.centerRight,
  }) {
    return LinearGradient(begin: begin, end: end, colors: neonGradient);
  }

  /// Box shadow for neon glow effect.
  static List<BoxShadow> neonGlow({
    Color color = neonCyan,
    double blurRadius = 20,
    double spreadRadius = 0,
    Offset offset = Offset.zero,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.4),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: offset,
      ),
    ];
  }

  /// Glassmorphism decoration for cards.
  static BoxDecoration glassDecoration({
    double radius = 16,
    Color? glowColor,
    double glowBlur = 0,
  }) {
    return BoxDecoration(
      color: glassBg,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: glassBorder, width: 1),
      boxShadow: glowColor != null
          ? [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.15),
                blurRadius: glowBlur,
                spreadRadius: 0,
              ),
            ]
          : null,
    );
  }

  /// Gradient text style (cyan → purple).
  static LinearGradient textGradient = const LinearGradient(
    colors: [neonCyan, neonPurple],
  );

  /// ShaderMask widget for gradient text.
  static Widget gradientText(
    String text, {
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
    TextAlign textAlign = TextAlign.center,
    List<Color>? colors,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors ?? neonGradient,
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Build the app's ThemeData.
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDarkest,
      colorScheme: ColorScheme.dark(
        primary: neonCyan,
        secondary: neonPurple,
        surface: bgCard,
        error: neonPink,
        onPrimary: bgDarkest,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        bodyLarge: GoogleFonts.inter(color: textPrimary),
        bodyMedium: GoogleFonts.inter(color: textSecondary),
        bodySmall: GoogleFonts.inter(color: textMuted),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontSize: 18,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neonCyan, width: 1.5),
        ),
        labelStyle: GoogleFonts.inter(color: textSecondary),
        hintStyle: GoogleFonts.inter(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonCyan,
          foregroundColor: bgDarkest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          elevation: 0,
          shadowColor: neonCyan.withValues(alpha: 0.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: glassBorder),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: bgCardLight,
        contentTextStyle: GoogleFonts.inter(color: textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: glassBorder),
        ),
      ),
    );
  }
}
