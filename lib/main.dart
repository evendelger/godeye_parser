import 'package:flutter/material.dart';
import 'package:godeye_parser/godeye_parser_app.dart';
import 'package:godeye_parser/service_locator.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

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

  DatabaseHelper.instance.close();
}
