import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class DataProvider {
  DataProvider(this.filesPath) {
    _convertDataFileToMap();
  }

  String filesPath;
  Map<String, List<List<String>>> dataPhonesMap = {};

  void changePath(String path) => filesPath = path;

  Future<void> _convertDataFileToMap() async {
    final data = Stream.fromFuture(rootBundle.loadString('assets/data.csv'))
        .transform(const LineSplitter());

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
      return '';
    }
    return await file.readAsString();
  }
}
