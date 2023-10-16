import 'package:flutter/material.dart';
import 'package:godeye_parser/ui/navigation/navigation.dart';
import 'package:godeye_parser/ui/theme/theme.dart';

class GodEyeParserApp extends StatelessWidget {
  const GodEyeParserApp({super.key});

  static final navigation = Navigation.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF364091),
          primary: const Color(0xFF364091),
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
            color: ColorsList.primaryWithSmallOpacity,
          ),
          titleMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ColorsList.primaryWithSmallOpacity,
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
        useMaterial3: true,
      ),
      routes: navigation.routes,
      initialRoute: navigation.initialRoute(),
    );
  }
}
