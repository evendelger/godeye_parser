import 'package:flutter/material.dart';
import 'package:godeye_parser/ui/navigation/navigation.dart';
import 'package:godeye_parser/ui/theme/theme.dart';

class GodEyeParserApp extends StatelessWidget {
  const GodEyeParserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeClass.instance.themeData,
      routerConfig: router,
    );
  }
}
