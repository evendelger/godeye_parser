import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class DataProvider {
  DataProvider(this.filesPath) {
    _convertDataFileToMap();
  }

  String filesPath;
  Map<String, List<List<String>>> dataPhonesMap = {};

  void changePath(String path) => filesPath = path;

  Future<void> _convertDataFileToMap() async {
    final dataFile = File('assets/data.csv');
    Stream<List> inputStream = dataFile.openRead();
    final data =
        inputStream.transform(utf8.decoder).transform(const LineSplitter());

    await for (var line in data) {
      final row = line.split(';');

      final phoneCode = row[0];
      final listOfData = dataPhonesMap[phoneCode] ?? [];
      listOfData.add(row.sublist(1));
      dataPhonesMap[phoneCode] = listOfData;
    }
  }

  Future<String> _getDirectory(String name) async {
    final firstDir = "$filesPath\\$name.html";
    final secondDir = "$filesPath\\${name.replaceAll(' ', '_')}.html";

    if (await File(firstDir).exists()) {
      return firstDir;
    } else if (await File(secondDir).exists()) {
      return secondDir;
    }
    return '';
  }

  Future<String> readPersonFile(String name) async {
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
