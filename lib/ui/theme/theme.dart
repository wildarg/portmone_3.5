import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const Color _black = Color(0xFF333333);

ColorScheme _scheme() {
  final Color black = Color(0xFF222222);

  return ColorScheme.light(
    primary: Color(0xFF228b22),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFdef7de),
    onPrimaryContainer: Color(0xFF1b6f1b),
    secondary: Color(0xFF613F75),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFefe9f3),
    onSecondaryContainer: Color(0xFF4e325e),
    tertiary: Color(0xFFffc4eb),
    onTertiary: black,
    tertiaryContainer: Color(0xFFfff3fb),
    onTertiaryContainer: Color(0xFFc34e9c),
    error: Color(0xFFFF5454),//Color(0xFFf21b3f),
    onError: Colors.white,
    errorContainer: Color(0xFFfee8ec),
    onErrorContainer: Color(0xFF911026),
    surface: Color(0xFFF8F9FA),
    surfaceDim: Color(0xFFF0F2F4),
    surfaceBright: Colors.brown,//Colors.white,
    surfaceContainerLowest: Colors.amber,//Color(0xFFF8F9FA),
    surfaceContainerLow: Color(0xFFFFFFFF),
    surfaceContainer: Colors.white,//Color(0xFFE6E0E9),
    surfaceContainerHigh: Color(0xFFF8F9FA),
    surfaceContainerHighest: Color(0xFFD3D1D4),
    onSurface: black,
    onSurfaceVariant: Color(0xFF666666),
    outline: Color(0xFFcecece),
  );
}

ColorScheme _lightColorScheme = const ColorScheme.light(
        primary: Color(0xFF228b22),
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFdef7de),
        onPrimaryContainer: Color(0xFF1b6f1b),
        secondary: Color(0xFFc68346),
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFfdecdd),
        onSecondaryContainer: Color(0xFF512d08),
        tertiary: Color(0xFF313b46),
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFdde3ea),
        onTertiaryContainer: Color(0xFF0b141d),
        error: Color(0xFFFF5454),
        onError: Colors.white,
        errorContainer: Color(0xFFfee8ec),
        onErrorContainer: Color(0xFF911026),
        surface: Color(0xFFF8F9FA),
        surfaceDim: Color(0xFFF0F2F4),
        surfaceContainerLow: Color(0xFFFFFFFF),
        surfaceContainer: Colors.white,//Color(0xFFE6E0E9),
        surfaceContainerHigh: Color(0xFFF8F9FA),
        surfaceContainerHighest: Color(0xFFD3D1D4),
        onSurface: _black,
        onSurfaceVariant: Color(0xFF666666),
        outline: Color(0xFFcecece),
      );


TextTheme _textTheme() {
  final primaryTextTheme = GoogleFonts.comfortaaTextTheme();
  final secondaryTextTheme = GoogleFonts.montserratTextTheme();
  final textTheme = primaryTextTheme.copyWith(
    displaySmall: secondaryTextTheme.displaySmall,
    displayLarge: secondaryTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.w100),
    headlineSmall: secondaryTextTheme.headlineSmall,
    labelLarge: secondaryTextTheme.labelLarge,
  );
  return textTheme;
}


ThemeData appTheme = ThemeData(
  colorScheme: _scheme(),
  textTheme: _textTheme(),
  canvasColor: _lightColorScheme.surface,
  splashColor: _lightColorScheme.primary.withAlpha(50),
  highlightColor: _lightColorScheme.primary.withAlpha(50),
  useMaterial3: true,
);

