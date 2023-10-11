import 'package:phone_corrector/features/full_file_search/full_file_search.dart';
import 'package:phone_corrector/features/mini_file_search/mini_file_search.dart';
import 'package:phone_corrector/features/mini_search_menu/mini_search_menu.dart';
import 'package:phone_corrector/features/mini_text_search/mini_text_search.dart';
import 'package:phone_corrector/features/size_transition/size_transition.dart';
import 'package:phone_corrector/services/screen_size_service.dart';

abstract class MainNavigationRouteNames {
  static const transitionScreen = '/';
  static const fullSizeScreen = '/full_size';
  static const miniSizeScreen = '/mini_size';
  static const miniFileSearch = '/mini_size/file_search';
  static const miniTextSearch = '/mini_size/text_search';
}

class Navigation {
  Navigation({required this.screenSizeService});

  final ScreenSizeService screenSizeService;

  String initialRoute() => screenSizeService.isFullSize()
      ? MainNavigationRouteNames.fullSizeScreen
      : MainNavigationRouteNames.miniSizeScreen;

  final routes = {
    MainNavigationRouteNames.transitionScreen: (_) =>
        const SizeTransitionScreen(),
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
