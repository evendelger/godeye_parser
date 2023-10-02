import 'package:flutter/material.dart';
import 'package:phone_corrector/domain/data/storage_keys.dart';
import 'package:phone_corrector/service_locator.dart';
import 'package:phone_corrector/services/screen_size_service.dart';
import 'package:phone_corrector/ui/navigation/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class MiniSearchScreen extends StatefulWidget {
  const MiniSearchScreen({super.key});

  @override
  State<MiniSearchScreen> createState() => _MiniSearchScreenState();
}

class _MiniSearchScreenState extends State<MiniSearchScreen> {
  @override
  void initState() {
    windowManager.setMinimumSize(getIt<ScreenSizeService>().getMinimumSize);
    windowManager.setSize(getIt<ScreenSizeService>().getInitialSize);
    super.initState();
  }

  Future<void> _changeSize() async {
    getIt<SharedPreferences>().setString(
      StorageKeys.appSizeKey,
      StorageSizeValue.fullSize.value,
    );
    await Navigator.of(context)
        .popAndPushNamed(MainNavigationRouteNames.fullSizeApp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _changeSize,
          icon: Icon(Icons.change_circle),
        ),
      ),
      body: Center(
        child: Text('Хаааай'),
      ),
    );
  }
}
