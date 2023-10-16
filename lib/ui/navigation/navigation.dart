import 'package:godeye_parser/features/full_file_search/full_file_search.dart';
import 'package:godeye_parser/features/mini_file_search/mini_file_search.dart';
import 'package:godeye_parser/features/mini_search_menu/mini_search_menu.dart';
import 'package:godeye_parser/features/mini_text_search/mini_text_search.dart';
import 'package:godeye_parser/service_locator.dart';
import 'package:godeye_parser/services/screen_size_service.dart';

abstract class MainNavigationRouteNames {
  static const fullSizeScreen = '/full_size';
  static const miniSizeScreen = '/mini_size';
  static const miniFileSearch = '/mini_size/file_search';
  static const miniTextSearch = '/mini_size/text_search';
}

class Navigation {
  Navigation._({required this.screenSizeService});

  static Navigation get instance => _instance;
  static final _instance =
      Navigation._(screenSizeService: getIt<ScreenSizeService>());

  final ScreenSizeService screenSizeService;

  String initialRoute() => screenSizeService.isFullSize()
      ? MainNavigationRouteNames.fullSizeScreen
      : MainNavigationRouteNames.miniSizeScreen;

  final routes = {
    MainNavigationRouteNames.fullSizeScreen: (_) =>
        const FullFileSearchScreen(),
    MainNavigationRouteNames.miniSizeScreen: (_) =>
        const MiniSearchMenuScreen(),
    MainNavigationRouteNames.miniFileSearch: (_) =>
        const MiniFileSeacrhScreen(),
    MainNavigationRouteNames.miniTextSearch: (_) =>
        const MiniTextSearchScreen(),
  };
}
