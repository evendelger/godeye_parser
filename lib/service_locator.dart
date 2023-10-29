import 'package:get_it/get_it.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:godeye_parser/domain/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.I;

class ServiceLocator {
  static Future<void> initLocator() async {
    // Database
    if (await DatabaseHelper.instance.tablesAreEmpty()) {
      await DatabaseHelper.instance.fillDatabases(true);
    }
    // SharedPreferences
    getIt.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance(),
    );
    // DataProvider
    getIt.registerSingleton<DataProvider>(
      DataProvider(
        getIt<SharedPreferences>().getString(StorageKeys.filesFolderKey) ?? '',
      ),
    );
    // ScreenSizeService
    getIt.registerSingleton<ScreenSizeService>(const ScreenSizeService());
    // PhonesService
    getIt.registerLazySingleton(
      () => PhonesService(
        dataProvider: getIt<DataProvider>(),
      ),
    );
    // repository
    getIt.registerSingleton<AbstractPhonesDataRepository>(
      PhonesDataRepository(
        dataProvider: getIt<DataProvider>(),
        phonesService: getIt<PhonesService>(),
      ),
    );
  }
}
