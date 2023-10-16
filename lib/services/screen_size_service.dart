import 'dart:ui';

import 'package:godeye_parser/domain/data/storage_keys.dart';
import 'package:godeye_parser/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _SizeTypes {
  fullWindowInitial(Size(1600, 900)),
  fullWindowMinimum(Size(1400, 720)),
  fullWindowMaximum(Size(3000, 3000)),
  miniWindowInitial(Size(425, 500)),
  miniWindowMinimum(Size(425, 500)),
  miniWindowMaximum(Size(700, 900));

  final Size size;
  const _SizeTypes(this.size);
}

class ScreenSizeService {
  const ScreenSizeService();

  bool isFullSize() {
    final size = getIt<SharedPreferences>().getString(StorageKeys.appSizeKey);
    switch (size) {
      case ('full'):
        return true;
      case ('mini'):
        return false;
      default:
        return true;
    }
  }

  Size get getInitialSize => isFullSize()
      ? _SizeTypes.fullWindowInitial.size
      : _SizeTypes.miniWindowInitial.size;

  Size get getMinimumSize => isFullSize()
      ? _SizeTypes.fullWindowMinimum.size
      : _SizeTypes.miniWindowMinimum.size;

  Size get getMaximumSize => isFullSize()
      ? _SizeTypes.fullWindowMaximum.size
      : _SizeTypes.miniWindowMaximum.size;
}
