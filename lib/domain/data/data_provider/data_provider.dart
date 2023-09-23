import 'dart:developer';
import 'dart:io';

import 'package:phone_corrector/domain/data/data_provider/abstract_Data_provider.dart';

class DataProvider implements AbstractDataProvider {
  const DataProvider();

  // TODO: добавить выбор папки при запуске программы, т.е. через hive сохранять это
  static const filesPath = r"C:\Users\even\Downloads\Telegram Desktop\";

  Future<String> _getDirectory(String name) async {
    final firstDir = "$filesPath$name.html";
    final secondDir = "$filesPath${name.replaceAll(' ', '_')}.html";

    log(firstDir);
    log(secondDir);

    if (await File(firstDir).exists()) {
      return firstDir;
    } else if (await File(secondDir).exists()) {
      return secondDir;
    }
    return '';
  }

  @override
  Future<String> readFile(String name) async {
    final file = File(await _getDirectory(name));
    if (file.path.isEmpty) {
      // TODO: доработать обработку ошибок
      // выбросить кастомную ошибку
      log("не удается найти файл");
      return '';
    }
    return await file.readAsString();
  }
}
