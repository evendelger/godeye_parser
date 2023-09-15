import 'package:flutter/material.dart';
import 'features/file_search/view/view.dart';

class PhoneApp extends StatelessWidget {
  const PhoneApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      home: const FileSearchScreen(),
    );
  }
}
