import 'package:flutter/material.dart';

abstract final class ColorsList {
  static const primary = Color(0xFF364091);
  static final primaryWithSmallOpacity = primary.withOpacity(0.9);
  static final primaryWithMediumOpacity = primary.withOpacity(0.25);
  static final primaryWithLargeOpacity = primary.withOpacity(0.15);
  static const darkPrimary = Color.fromARGB(255, 28, 26, 56);

  static final whiteWithOpacity = Colors.white.withOpacity(0.7);
  static const hoverColor = Colors.white12;

  static final blockBackgroundColor = Colors.black.withOpacity(0.12);
  static const blackWithLargeOpacity = Colors.black12;
  static final blackWithMediumOpacity = Colors.black.withOpacity(0.5);
  static final hintTextFieldColor = Colors.black.withOpacity(0.3);
  static final hintRegionTextColor = Colors.black.withOpacity(0.4);

  static final deleteColor = Colors.red.shade400;

  static const waitingColor = Colors.black;
  static final progressColor = Colors.yellow.shade800;
  static final successColor = Colors.greenAccent.shade700;
  static const errorColor = Colors.red;

  static final dataGreenColor = Colors.green.shade700;
  static const dataBlackColor = Colors.black87;
  static const dataPinkColor = Colors.pink;
  static final dataOrangeColor = Colors.orange.shade800;
  static const dataBlueColor = Colors.blueAccent;

  static const greenColorsMap = {
    0: Color(0xFF388E3C),
    1: Color(0xFF317E35),
    2: Color(0xFF2A6D2D),
    3: Color(0xFF245D26),
    4: Color(0xFF1D4D1F),
    5: Color(0xFF163C17),
  };

  static const redColorsMap = {
    0: Color(0xFFE91E63),
    1: Color(0xFFD51C5B),
    2: Color(0xFFC11952),
    3: Color(0xFFAE174A),
    4: Color(0xFF9A1542),
    5: Color(0xFF861239),
  };
}

class ThemeClass {
  ThemeClass._();

  static ThemeClass get instance => _instance;
  static final _instance = ThemeClass._();

  final themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF364091),
    ),
    textTheme: TextTheme(
      labelSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      labelMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      labelLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF364091).withOpacity(0.9),
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF364091).withOpacity(0.9),
      ),
      bodyMedium: const TextStyle(
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
      ),
      bodySmall: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: const TextStyle(
        fontWeight: FontWeight.w800,
      ),
      headlineSmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
