import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_corrector/domain/data/data.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/features/full_file_search/full_file_search.dart';
import 'package:phone_corrector/features/full_text_search/full_text_search.dart';
import 'package:phone_corrector/repositories/abstract_phones_repository.dart';
import 'package:phone_corrector/service_locator.dart';
import 'package:phone_corrector/services/screen_size_service.dart';
import 'package:phone_corrector/ui/navigation/navigation.dart';
import 'package:phone_corrector/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

enum DialogType {
  folder,
  client,
}

class FullFileSearchScreen extends StatefulWidget {
  const FullFileSearchScreen({super.key});

  @override
  State<FullFileSearchScreen> createState() => FullFileSearchScreenState();
}

class FullFileSearchScreenState extends State<FullFileSearchScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    windowManager.setSize(getIt<ScreenSizeService>().getInitialSize);
    windowManager.center();
    windowManager.setMinimumSize(getIt<ScreenSizeService>().getMinimumSize);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = getIt<SharedPreferences>();
      final folder = prefs.getString(StorageKeys.filesFolderKey);
      if (folder == null) {
        _showFolderDialog(context, DialogType.folder);
      }
    });
  }

  Future<void> _showFolderDialog(
      BuildContext context, DialogType dialogType) async {
    await showDialog(
      context: context,
      builder: (context) => const _FolderAlertDialog(),
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
          color: iconColor.withOpacity(0.7),
        ),
        selectedIcon: const Icon(
          Icons.file_open,
          size: iconSize,
          color: iconColor,
        ),
        label: Text(
          'Поиск по файлу',
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
      NavigationRailDestination(
        icon: Icon(
          Icons.text_fields_outlined,
          size: iconSize,
          color: iconColor.withOpacity(0.7),
        ),
        selectedIcon: const Icon(
          Icons.text_fields,
          size: iconSize,
          color: iconColor,
        ),
        label: Text(
          'Поиск по тексту',
          style: theme.textTheme.titleLarge,
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

  Future<void> changeSize() async {
    getIt<SharedPreferences>().setString(
      StorageKeys.appSizeKey,
      StorageSizeValue.miniSize.value,
    );
    await Navigator.of(context)
        .popAndPushNamed(MainNavigationRouteNames.miniSizeApp);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiProvider(
      providers: [
        Provider<FileSearchBloc>(
          create: (_) => FileSearchBloc(
            phonesRepository: getIt<AbstractPhonesDataRepository>(),
          ),
        ),
        Provider<SearchingDataList>(
          create: (_) => SearchingDataList.init(),
          lazy: false,
        ),
        Provider<TextBloc>(
          create: (_) => TextBloc(
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
                    ),
                    child: NavigationRail(
                      labelType: NavigationRailLabelType.all,
                      groupAlignment: -0.95,
                      elevation: 20,
                      backgroundColor: const Color(0xFF364091),
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
                            onPressed: changeSize,
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.stay_primary_portrait,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Изменить режим',
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocListener<FileSearchBloc, FileSearchState>(
              listener: (context, state) {
                // if (state is FilesStatusMessage) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     messageSnackbar(state.message),
                //   );
                // }
              },
              child: _switchScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FolderAlertDialog extends StatelessWidget {
  const _FolderAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );

    return AlertDialog(
      title: const Text(
        'Внимание',
        style: titleStyle,
      ),
      content: const Text(
        'Пожалуйста, выберите папку, где хранятся файлы с Telegram(иконка снизу слева)',
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _ClientAlertDialog extends StatelessWidget {
  const _ClientAlertDialog({
    super.key,
    required this.currentClient,
  });

  final String currentClient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const textStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    );

    return SimpleDialog(
      title: Text(
        'Выберите сайт для поиска',
        style: theme.textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
      children: [
        Wrap(
            direction: Axis.vertical,
            runAlignment: WrapAlignment.center,
            children: ApiClientsData.apiClientsList
                .map(
                  (client) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, client),
                    child: SingleItemAlertDialog(
                      width: 300,
                      item: client,
                      theme: theme,
                      textStyle: textStyle,
                    ),
                  ),
                )
                .toList()),
        Text(
          'Текущий сайт - $currentClient',
          style: textStyle.copyWith(color: Colors.green.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
