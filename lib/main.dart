import 'package:flutter/material.dart';
import 'package:godeye_parser/godeye_parser_app.dart';
import 'package:godeye_parser/service_locator.dart';
import 'package:godeye_parser/services/screen_size_service.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await ServiceLocator.initLocator();

  final windowOptions = WindowOptions(
    size: getIt<ScreenSizeService>().getInitialSize,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    title: 'GodEye Parser',
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  const phoneApp = GodEyeParserApp();
  runApp(phoneApp);
}
