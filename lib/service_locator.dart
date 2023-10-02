import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:phone_corrector/domain/data/data.dart';
import 'package:phone_corrector/repositories/repositories.dart';
import 'package:phone_corrector/services/phones_service.dart';
import 'package:phone_corrector/services/screen_size_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.I;

class ServiceLocator {
  static Future<void> initLocator() async {
    // Dio
    getIt.registerSingleton<Dio>(Dio());
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
