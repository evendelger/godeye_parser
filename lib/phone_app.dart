import 'package:flutter/material.dart';
import 'package:phone_corrector/service_locator.dart';
import 'package:phone_corrector/services/screen_size_service.dart';
import 'package:phone_corrector/ui/navigation/navigation.dart';

class PhoneApp extends StatelessWidget {
  const PhoneApp({super.key});

  static final navigation = Navigation(
    screenSizeService: getIt<ScreenSizeService>(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF364091)),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      routes: navigation.routes,
      initialRoute: navigation.initialRoute(),
    );
  }
}
