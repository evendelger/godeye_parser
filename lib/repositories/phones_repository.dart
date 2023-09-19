import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';

import 'package:phone_corrector/domain/api/api.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/repositories/abstract_phone_repository.dart';

class PhonesDataRepository implements AbstractPhonesDataRepository {
  const PhonesDataRepository({required this.apiClient});

  final AbstractApiClient apiClient;

  // TODO: добавить выбор папки при запуске программы, т.е. через hive сохранять это
  static const filesPath = r"C:\Users\even\Downloads\Telegram Desktop\";
  static final datePattern = RegExp(r'\d{2}\.\d{2}\.\d{4}');

  Future<String> _getDirectory(String name) async {
    final firstDir = "$filesPath$name.html";
    final secondDir = "$filesPath${name.replaceAll(' ', '_')}.html";

    if (await File(firstDir).exists()) {
      return firstDir;
    } else if (await File(secondDir).exists()) {
      return secondDir;
    }
    return '';
  }

  List<String> _getPhonesList(Element blockInfoList) {
    final phoneList = <String>[];

    try {
      final phoneBlock = blockInfoList.children
          .firstWhere((e) => e.children[0].text == "Телефоны:");
      phoneList.addAll(phoneBlock.children[1].text
          .split(', ')
          .where((phone) => phone.length == 11 && phone.startsWith('79')));
    } catch (e) {
      log(e.toString());
      return phoneList;
    }
    return phoneList;
  }

  List<SinglePersonModel> _collectModels(List<Element> blocksDataList) {
    final personModels = <SinglePersonModel>[];
    final addedPhones = <String>{};

    blocksDataList.sublist(2).forEach((block) {
      final contentList = block.children[0].children[1];

      var blockModel = BlockInfoModel();
      for (var dataMap in contentList.children) {
        final title = dataMap.children[0].text;

        if (title == "День рождения:") {
          final data = dataMap.children[1].text.trim();
          if (!datePattern.hasMatch(data)) continue;
          blockModel.dateOfBirth ??= DateFormat('dd.mm.yyyy').parse(data);
        } else if (title == "Телефон:") {
          final data = dataMap.children[1].text.trim();
          if (data.length != 11 || !data.startsWith("79")) continue;
          blockModel.phone ??= data;
        } else if (title == "Адрес:" ||
            title == "Фактический адрес:" ||
            title == "Регион проживания:" ||
            title == "Паспорт выдан:") {
          final data = dataMap.children[1].text.trim();
          blockModel.adress ??= data;
        }
      }

      if (blockModel.dateOfBirth != null) {
        if (blockModel.phone != null || blockModel.adress != null) {
          final index = personModels.indexWhere(
              (model) => model.dateOfBirth == blockModel.dateOfBirth);

          if (addedPhones.contains(blockModel.phone)) {
            final existedIndex = personModels.indexWhere(
                (model) => model.phoneNumbersList.contains(blockModel.phone));
            personModels[existedIndex].addDate(blockModel.dateOfBirth);
            personModels[existedIndex].addAdress(blockModel.adress);
          } else if (index != -1) {
            personModels[index].addAdress(blockModel.adress);
            if (blockModel.phone != null) {
              personModels[index].addPhone(blockModel.phone);
              addedPhones.add(blockModel.phone!);
            }
          } else {
            personModels.add(SinglePersonModel(
              dateOfBirth: blockModel.dateOfBirth,
              adress: blockModel.adress,
              phone: blockModel.phone,
            ));

            if (blockModel.phone != null) addedPhones.add(blockModel.phone!);
          }
        } else {
          final index = personModels.indexWhere(
              (model) => model.dateOfBirth == blockModel.dateOfBirth);
          if (index == -1) {
            personModels
                .add(SinglePersonModel(dateOfBirth: blockModel.dateOfBirth));
          }
        }
      } else {
        if (blockModel.phone != null) {
          final isNewPhone = !addedPhones.contains(blockModel.phone);

          if (isNewPhone) {
            personModels.add(SinglePersonModel(
              dateOfBirth: null,
              phone: blockModel.phone,
              adress: blockModel.adress,
            ));

            addedPhones.add(blockModel.phone!);
          } else {
            final index = personModels.indexWhere(
                (model) => model.phoneNumbersList.contains(blockModel.phone));
            personModels[index].addPhone(blockModel.phone);
            personModels[index].addAdress(blockModel.adress);
          }
        }
      }
    });

    return personModels;
  }

  Future<PersonFileModel> _exploreFile(String name) async {
    final model = PersonFileModel(
      name: name,
      allPersonModels: [],
      allPhones: [],
    );
    final file = File(await _getDirectory(name));
    if (file.path.isEmpty) {
      // TODO: доработать обработку ошибок
      // выбросить кастомную ошибку
      log("не удается найти файл");
      return model;
    }

    final data = await file.readAsString();
    final document = parser.parse(data);

    final blocksDataList =
        document.getElementsByClassName("result_search_page")[0].children;
    final blockSummary =
        document.getElementById("menuSvodka")?.children[0].children[1];

    final allPhonesList = _getPhonesList(blockSummary!);
    final modelsAfterSearching = _collectModels(blocksDataList);

    model.allPersonModels.addAll(modelsAfterSearching);
    model.allPhones.addAll(allPhonesList);

    return model;
  }

  @override
  Future<PersonFileModel> getDataFromFile(String name) async {
    return await compute(_exploreFile, name);
  }
}
