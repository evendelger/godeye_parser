import 'dart:ui';

import 'package:phone_corrector/domain/data/storage_keys.dart';
import 'package:phone_corrector/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SizeTypes {
  fullWindowInitial(Size(1600, 900)),
  fullWindowMinimum(Size(1550, 700)),
  miniWindowInitial(Size(400, 500)),
  miniWindowMinimum(Size(350, 450));

  final Size size;
  const SizeTypes(this.size);
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
      ? SizeTypes.fullWindowInitial.size
      : SizeTypes.miniWindowInitial.size;

  Size get getMinimumSize => isFullSize()
      ? SizeTypes.fullWindowMinimum.size
      : SizeTypes.miniWindowMinimum.size;
}
