import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:godeye_parser/features/full_file_search/full_file_search.dart';
import 'package:godeye_parser/features/full_text_search/full_text_search.dart';
import 'package:godeye_parser/domain/domain.dart';
import 'package:godeye_parser/service_locator.dart';
import 'package:godeye_parser/ui/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class FullFileSearchScreen extends StatefulWidget {
  const FullFileSearchScreen({super.key});

  @override
  State<FullFileSearchScreen> createState() => FullFileSearchScreenState();
}

class FullFileSearchScreenState extends State<FullFileSearchScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    windowManager.setMaximumSize(getIt<ScreenSizeService>().getMaximumSize);
    windowManager.setMinimumSize(getIt<ScreenSizeService>().getMinimumSize);
    windowManager.setSize(getIt<ScreenSizeService>().getInitialSize);
    windowManager.center();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = getIt<SharedPreferences>();
      final folder = prefs.getString(StorageKeys.filesFolderKey);
      if (folder == null) {
        _showFolderDialog(context);
      }
    });
  }

  Future<void> _showFolderDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const FolderAlertDialog(),
    );
  }

  List<NavigationRailDestination> _destinations(ThemeData theme) {
    const iconSize = 55.0;
    const iconColor = Colors.white;

    return [
      NavigationRailDestination(
        icon: Icon(
          Icons.file_open_outlined,
          size: iconSize,
          color: iconColor.withOpacity(0.5),
        ),
        selectedIcon: const Icon(
          Icons.file_open,
          size: iconSize,
          color: iconColor,
        ),
        label: Text(
          'Поиск по файлу',
          style: theme.textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ),
      NavigationRailDestination(
        icon: Icon(
          Icons.text_fields_outlined,
          size: iconSize,
          color: iconColor.withOpacity(0.5),
        ),
        selectedIcon: const Icon(
          Icons.text_fields,
          size: iconSize,
          color: iconColor,
        ),
        label: Text(
          'Поиск по тексту',
          style: theme.textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  Widget _switchScreen() {
    switch (_selectedIndex) {
      case 0:
        return const MainPage();
      case 1:
        return const FullTextSearchScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> changeSize(BuildContext context) async {
    getIt<SharedPreferences>().setString(
      StorageKeys.appSizeKey,
      StorageSizeValue.miniSize.value,
    );
    context.goNamed('miniSearchMenu');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiProvider(
      providers: [
        Provider<FullSearchBloc>(
          create: (_) => FullSearchBloc(
            phonesRepository: getIt<AbstractPhonesDataRepository>(),
          ),
        ),
        Provider<TextSearchBloc>(
          create: (_) => TextSearchBloc(
            phonesRepository: getIt<AbstractPhonesDataRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 100,
              child: Stack(
                children: [
                  Theme(
                    data: ThemeData(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                    ),
                    child: NavigationRail(
                      useIndicator: false,
                      indicatorColor: Colors.transparent,
                      labelType: NavigationRailLabelType.all,
                      groupAlignment: -0.95,
                      elevation: 20,
                      backgroundColor: ColorsList.primary,
                      destinations: _destinations.call(theme),
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (value) {
                        setState(() {
                          _selectedIndex = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => changeSize(context),
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.stay_primary_portrait,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Изменить режим',
                            style: theme.textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _switchScreen(),
          ],
        ),
      ),
    );
  }
}
