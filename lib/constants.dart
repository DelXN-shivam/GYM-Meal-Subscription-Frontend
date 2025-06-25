import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors
// const Color primaryColor = Color(0xFF007BFF);
const Color primaryColor = Color.fromRGBO(147, 197, 114, 1);
const Color secondaryColor = Color(0xFF007BFF);
const Color navBarPrimaryColor = Color.fromRGBO(107, 199, 46, 1);
const Color navBarSecondaryColor = Color.fromRGBO(116, 194, 64, 1);
const Color navBarTertiaryColor = Color.fromRGBO(167, 253, 109, 1);

// Light Theme Colors
const Color lightPrimaryColor = Color(0xFF8BC34A); // Example, adjust as needed
const Color lightSecondaryColor = Color(0xFF007BFF);
const Color lightBackgroundColor = Color(0xFFF5F5F5);
const Color lightSurfaceColor = Color(0xFFFFFFFF);
const Color lightOnPrimaryColor = Color(0xFFFFFFFF);
const Color lightOnSecondaryColor = Color(0xFFFFFFFF);
const Color lightOnBackgroundColor = Color(0xFF222222);
const Color lightOnSurfaceColor = Color(0xFF222222);

// Dark Theme Colors (already defined above)
const Color darkPrimaryColor = primaryColor;
const Color darkSecondaryColor = secondaryColor;
const Color darkBackgroundColor = Color(0xFF0A0A0A);
const Color darkSurfaceColor = Color(0xFF181818);
const Color darkOnPrimaryColor = Color(0xFFFFFFFF);
const Color darkOnSecondaryColor = Color(0xFFFFFFFF);
const Color darkOnBackgroundColor = Color(0xFFFFFFFF);
const Color darkOnSurfaceColor = Color(0xFFFFFFFF);

// Light ThemeData
final ThemeData lightThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: lightPrimaryColor,
    onPrimary: lightOnPrimaryColor,
    secondary: lightSecondaryColor,
    onSecondary: lightOnSecondaryColor,
    background: lightBackgroundColor,
    onBackground: lightOnBackgroundColor,
    surface: lightSurfaceColor,
    onSurface: lightOnSurfaceColor,
    error: Colors.red,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: lightBackgroundColor,
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);

// Dark ThemeData
final ThemeData darkThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: darkPrimaryColor,
    onPrimary: darkOnPrimaryColor,
    secondary: darkSecondaryColor,
    onSecondary: darkOnSecondaryColor,
    background: darkBackgroundColor,
    onBackground: darkOnBackgroundColor,
    surface: darkSurfaceColor,
    onSurface: darkOnSurfaceColor,
    error: Colors.red,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: darkBackgroundColor,
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
