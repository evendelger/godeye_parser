import 'package:flutter/material.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/features/file_search/bloc/files_bloc.dart';
import 'package:phone_corrector/features/file_search/widgets/widgets.dart';
import 'package:phone_corrector/features/text_search/bloc/text_bloc.dart';
import 'package:phone_corrector/features/text_search/view/text_search_screen.dart';
import 'package:provider/provider.dart';

class FileSearchScreen extends StatefulWidget {
  const FileSearchScreen({super.key});

  @override
  State<FileSearchScreen> createState() => FileSearchScreenState();
}

class FileSearchScreenState extends State<FileSearchScreen> {
  int _selectedIndex = 0;

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
        return const TextSearchScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiProvider(
      providers: [
        Provider<FilesBloc>(
          create: (_) => FilesBloc(),
          lazy: false,
        ),
        Provider<SearchingDataList>(
          create: (_) => SearchingDataList.init(),
          lazy: false,
        ),
        Provider<TextBloc>(
          create: (_) => TextBloc(),
          lazy: true,
        ),
      ],
      child: Scaffold(
        body: Row(
          children: [
            Theme(
              data: ThemeData(
                splashFactory: NoSplash.splashFactory,
              ),
              child: SizedBox(
                width: 100,
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
            ),
            _switchScreen(),
          ],
        ),
      ),
    );
  }
}
