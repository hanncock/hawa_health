import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Hawa Health design tokens — deep purple & cream palette.
abstract final class HawaColors {
  static const cream = Color(0xFFFBF8FF);
  static const creamDark = Color(0xFFF2EDF8);
  static const white = Color(0xFFFFFFFF);
  static const primary = Color(0xFF5C2A6B);
  static const secondary = Color(0xFFBB88EB);
  static const accent = Color(0xFFFF5BAA);
  static const ink = Color(0xFF1A0D24);

  static Color get ink60 => ink.withValues(alpha: 0.6);
  static Color get ink12 => ink.withValues(alpha: 0.12);
  static Color get ink6 => ink.withValues(alpha: 0.06);
  static Color get accentGlow => accent.withValues(alpha: 0.25);
  static Color get cardShadow => ink.withValues(alpha: 0.06);
}

abstract final class HawaRadius {
  static const pill = 999.0;
  static const large = 24.0;
  static const medium = 16.0;
  static const small = 8.0;
}

abstract final class HawaCurves {
  static const spring = Cubic(0.34, 1.56, 0.64, 1);
  static const smooth = Cubic(0.22, 1, 0.36, 1);
}

abstract final class HawaTypography {
  static TextStyle display(String text, {double size = 28, FontStyle? style}) {
    return GoogleFonts.oldStandardTt(
      fontSize: size,
      fontWeight: FontWeight.w400,
      fontStyle: style ?? FontStyle.italic,
      color: HawaColors.ink,
      height: 1.2,
    );
  }

  static TextStyle displayPrimary(String text, {double size = 28}) {
    return display(text, size: size).copyWith(color: HawaColors.primary);
  }

  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.dmSans(
      fontSize: size,
      fontWeight: weight,
      color: color ?? HawaColors.ink,
      height: height ?? 1.5,
    );
  }

  static TextStyle bodySecondary({double size = 14}) =>
      body(size: size, color: HawaColors.ink60);

  static TextStyle label({FontWeight weight = FontWeight.w600}) =>
      body(size: 12, weight: weight, color: HawaColors.ink60);

  static TextStyle button() =>
      body(size: 16, weight: FontWeight.w700, color: HawaColors.white);
}

abstract final class HawaShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: HawaColors.cardShadow,
          offset: const Offset(0, 8),
          blurRadius: 24,
        ),
      ];

  static List<BoxShadow> get fab => [
        BoxShadow(
          color: HawaColors.accentGlow,
          offset: const Offset(0, 6),
          blurRadius: 20,
        ),
      ];
}

ThemeData buildHawaTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: HawaColors.cream,
    primaryColor: HawaColors.primary,
    colorScheme: const ColorScheme.light(
      primary: HawaColors.primary,
      secondary: HawaColors.secondary,
      tertiary: HawaColors.accent,
      surface: HawaColors.white,
      onPrimary: HawaColors.white,
      onSecondary: HawaColors.ink,
      onSurface: HawaColors.ink,
    ),
    dividerColor: HawaColors.ink12,
    splashFactory: InkRipple.splashFactory,
  );

  return base.copyWith(
    textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
      bodyColor: HawaColors.ink,
      displayColor: HawaColors.ink,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: HawaColors.cream,
      foregroundColor: HawaColors.ink,
      titleTextStyle: HawaTypography.body(size: 18, weight: FontWeight.w600),
      iconTheme: const IconThemeData(color: HawaColors.ink),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: HawaColors.primary,
      contentTextStyle: HawaTypography.body(color: HawaColors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HawaRadius.medium),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: HawaColors.white,
      headerBackgroundColor: HawaColors.primary,
      headerForegroundColor: HawaColors.white,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return HawaColors.white;
        return HawaColors.ink;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return HawaColors.primary;
        return Colors.transparent;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return HawaColors.primary;
        return HawaColors.white;
      }),
      side: BorderSide(color: HawaColors.ink12, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HawaRadius.small),
      ),
    ),
  );
}

String greetingForTime() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}
