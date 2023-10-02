import 'package:phone_corrector/features/full_file_search/full_file_search.dart';
import 'package:phone_corrector/features/mini_search/mini_search.dart';
import 'package:phone_corrector/features/size_transition/size_transition.dart';
import 'package:phone_corrector/services/screen_size_service.dart';

abstract class MainNavigationRouteNames {
  static const transitionScreen = '/';
  static const fullSizeApp = '/full_size';
  static const miniSizeApp = '/mini_size';
}

class Navigation {
  Navigation({required this.screenSizeService});

  final ScreenSizeService screenSizeService;

  String initialRoute() => screenSizeService.isFullSize()
      ? MainNavigationRouteNames.fullSizeApp
      : MainNavigationRouteNames.miniSizeApp;

  final routes = {
    MainNavigationRouteNames.transitionScreen: (_) =>
        const SizeTransitionScreen(),
    MainNavigationRouteNames.fullSizeApp: (_) => const FullFileSearchScreen(),
    MainNavigationRouteNames.miniSizeApp: (_) => const MiniSearchScreen(),
  };
}
