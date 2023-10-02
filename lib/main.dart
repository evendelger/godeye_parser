import 'package:flutter/material.dart';
import 'package:phone_corrector/phone_app.dart';
import 'package:phone_corrector/service_locator.dart';
import 'package:phone_corrector/services/screen_size_service.dart';
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
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  const phoneApp = PhoneApp();
  runApp(phoneApp);
}
