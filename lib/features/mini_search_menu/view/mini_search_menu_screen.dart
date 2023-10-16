import 'package:flutter/material.dart';
import 'package:godeye_parser/domain/data/storage_keys.dart';
import 'package:godeye_parser/features/mini_search_menu/widgets/widgets.dart';
import 'package:godeye_parser/service_locator.dart';
import 'package:godeye_parser/services/screen_size_service.dart';
import 'package:godeye_parser/ui/navigation/navigation.dart';
import 'package:godeye_parser/ui/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class MiniSearchMenuScreen extends StatefulWidget {
  const MiniSearchMenuScreen({super.key});

  @override
  State<MiniSearchMenuScreen> createState() => _MiniSearchMenuScreenState();
}

class _MiniSearchMenuScreenState extends State<MiniSearchMenuScreen> {
  @override
  void initState() {
    windowManager.setMaximumSize(getIt<ScreenSizeService>().getMaximumSize);
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
        .popAndPushNamed(MainNavigationRouteNames.fullSizeScreen);
  }

  void _navigate(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsList.primary,
      body: SizedBox(
        child: Column(
          children: [
            CustomListTile(
              titleText: 'Поиск по файлу',
              icon: Icons.file_open_outlined,
              onTap: () => _navigate(MainNavigationRouteNames.miniFileSearch),
              dividerOnBotom: true,
            ),
            CustomListTile(
              titleText: 'Поиск по тексту',
              icon: Icons.text_fields,
              onTap: () => _navigate(MainNavigationRouteNames.miniTextSearch),
              dividerOnBotom: true,
            ),
            const Spacer(),
            CustomListTile(
              titleText: 'Выйти',
              icon: Icons.exit_to_app,
              onTap: _changeSize,
              dividerOnBotom: false,
            ),
          ],
        ),
      ),
    );
  }
}
