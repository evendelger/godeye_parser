import 'package:flutter/material.dart';
import 'package:phone_corrector/domain/data/storage_keys.dart';
import 'package:phone_corrector/service_locator.dart';
import 'package:phone_corrector/services/screen_size_service.dart';
import 'package:phone_corrector/ui/navigation/navigation.dart';
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
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
        child: Column(
          children: [
            _CustomListTile(
              titleText: 'Поиск по файлу',
              icon: Icons.file_open_outlined,
              onTap: () => _navigate(MainNavigationRouteNames.miniFileSearch),
              dividerOnBotom: true,
            ),
            _CustomListTile(
              titleText: 'Поиск по тексту',
              icon: Icons.text_fields,
              onTap: () => _navigate(MainNavigationRouteNames.miniTextSearch),
              dividerOnBotom: true,
            ),
            const Spacer(),
            _CustomListTile(
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

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    super.key,
    required this.titleText,
    required this.icon,
    required this.onTap,
    required this.dividerOnBotom,
  });

  final String titleText;
  final IconData icon;
  final VoidCallback onTap;
  final bool dividerOnBotom;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 18,
      color: Colors.white,
    );
    const borderSide = BorderSide(
      color: Colors.white,
      width: 2,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: dividerOnBotom ? BorderSide.none : borderSide,
          bottom: dividerOnBotom ? borderSide : BorderSide.none,
        ),
      ),
      child: ListTile(
        hoverColor: Colors.white12,
        iconColor: Colors.white,
        leading: Icon(icon),
        title: Text(
          titleText,
          style: textStyle,
        ),
        onTap: onTap,
      ),
    );
  }
}
