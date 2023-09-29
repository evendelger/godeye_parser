import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';

import 'package:phone_corrector/domain/api/api.dart';
import 'package:phone_corrector/domain/data/data_provider/abstract_Data_provider.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/repositories/abstract_phones_repository.dart';

class PhonesDataRepository implements AbstractPhonesDataRepository {
  const PhonesDataRepository({
    required this.apiClient,
    required this.dataProvider,
  });

  final AbstractApiClient apiClient;
  final AbstractDataProvider dataProvider;

  static const differenceInYears = 5;
  static final datePattern = RegExp(r'\d{2}\.\d{2}\.\d{4}');
  static final phonePattern = RegExp(r'(7|8)9\d{9}');

  List<String> _getPhonesList(Element blockInfoList) {
    final phoneList = <String>[];

    try {
      final phoneBlock = blockInfoList.children
          .firstWhere((e) => e.children[0].text == "Телефоны:");
      phoneList.addAll(phoneBlock.children[1].text.split(', ').where(
            (phone) =>
                phone.length == 11 && phone.startsWith('79') ||
                phone.startsWith('89'),
          ));
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

      var blockModel = BlockFileInfoModel();
      for (var dataMap in contentList.children) {
        final title = dataMap.children[0].text;

        if (title == "День рождения:") {
          final data = dataMap.children[1].text.trim();
          if (!datePattern.hasMatch(data)) continue;
          blockModel.dateOfBirth ??= DateFormat('dd.MM.yyyy').parse(data);
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

    personModels.removeWhere((model) => model.phoneNumbersList.isEmpty);

    return personModels;
  }

  Future<PersonFileModel> _exploreFile(String name) async {
    final data = await dataProvider.readFile(name);
    if (data.isEmpty) return PersonFileModel.empty(name: '');

    final document = parser.parse(data);

    final blocksDataList =
        document.getElementsByClassName("result_search_page")[0].children;
    final blockSummary =
        document.getElementById("menuSvodka")?.children[0].children[1];

    final allPhonesList = _getPhonesList(blockSummary!);
    final modelsAfterSearching = _collectModels(blocksDataList);

    return PersonFileModel(
      name: name,
      allPhones: allPhonesList,
      allPersonModels: modelsAfterSearching,
      stateModel: PersonStateModel(),
      fileFounded: true,
    );
  }

  @override
  Future<PersonFileModel> getDataFromFile(String name) async {
    return await compute(_exploreFile, name);
  }

  @override
  Future<List<String>> searchByRegion(
    PersonFileModel model,
    String region,
  ) async {
    print(model.allPhones);
    final correctPhones = <String>[];

    for (int i = 0; i < model.allPhones!.length; i++) {
      final isCorrect =
          await apiClient.checkRegion(model.allPhones![i], region);
      if (isCorrect) correctPhones.add(model.allPhones![i]);
    }

    return correctPhones;
  }

  @override
  (List<String>, List<String>) searchByCity(
    PersonFileModel model,
    String city,
  ) {
    final cityRegionPhones = List<String>.empty(growable: true);
    final cityPhones = List<String>.empty(growable: true);

    for (int i = 0; i < model.allPersonModels!.length; i++) {
      final correctCity = model.allPersonModels![i].adressesList.firstWhere(
        (adress) => adress.toLowerCase().contains(city.toLowerCase().trim()),
        orElse: () => 'empty',
      );

      if (correctCity != 'empty') {
        if (model.stateModel.regionPhones != null) {
          final correctPhones =
              model.allPersonModels![i].phoneNumbersList.where(
            (phone) => model.stateModel.regionPhones!.contains(phone),
          );
          cityRegionPhones.addAll(correctPhones);
        }
        final correctPhones = model.allPersonModels![i].phoneNumbersList;
        cityPhones.addAll(correctPhones);
      }
    }

    return (cityRegionPhones, cityPhones);
  }

  @override
  (MapList, MapList) searchByExperience(
    PersonFileModel model,
    String experience,
  ) {
    final experienceRegionPhones = MapList.empty(growable: true);
    final experiencePhones = MapList.empty(growable: true);

    for (int i = 0; i < model.allPersonModels!.length; i++) {
      final singleModel = model.allPersonModels![i];
      if (singleModel.dateOfBirth == null) continue;

      final isCorrectedDate = ((DateTime.now().year - 23) -
                  (singleModel.dateOfBirth!.year + int.parse(experience)))
              .abs() <=
          differenceInYears;

      if (isCorrectedDate) {
        if (model.stateModel.regionPhones != null) {
          final correctedPhones = singleModel.phoneNumbersList.where(
            (phone) => model.stateModel.regionPhones!.contains(phone),
          );
          if (correctedPhones.isEmpty) continue;
          experiencePhones.add({
            DateFormat('dd-MM-yyyy').format(singleModel.dateOfBirth!):
                correctedPhones.toList()
          });
        } else {
          final allPhones = singleModel.phoneNumbersList;
          experiencePhones.add({
            DateFormat('dd-MM-yyyy').format(singleModel.dateOfBirth!):
                allPhones.toList()
          });
        }
      }
    }

    return (experienceRegionPhones, experiencePhones);
  }

  @override
  Future<(List<String>, List<String>)> searchByText(
    String text,
    String region,
  ) async {
    final List<String> correctedPhones = [];
    final List<String> allPhones = [];

    final matchedPhones = phonePattern.allMatches(text);
    for (var match in matchedPhones) {
      final phone = match.group(0);
      if (phone != null) {
        allPhones.add(phone);
        if (await apiClient.checkRegion(phone, region)) {
          correctedPhones.add(phone);
        }
      }
    }

    return (correctedPhones, allPhones);
  }
}
