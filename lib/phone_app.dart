import 'package:flutter/material.dart';
import 'features/file_search/view/view.dart';

class PhoneApp extends StatelessWidget {
  const PhoneApp({super.key});

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
        //splashFactory: NoSplash.splashFactory,
        useMaterial3: true,
      ),
      home: const FileSearchScreen(),
    );
  }
}
