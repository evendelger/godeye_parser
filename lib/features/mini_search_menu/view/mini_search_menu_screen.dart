import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:godeye_parser/features/mini_search_menu/widgets/widgets.dart';
import 'package:godeye_parser/service_locator.dart';
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
    context.goNamed('fullSearch');
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
              onTap: () => context.goNamed('miniFileSearch'),
              dividerOnBotom: true,
            ),
            CustomListTile(
              titleText: 'Поиск по тексту',
              icon: Icons.text_fields,
              onTap: () => context.goNamed('miniTextSearch'),
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
