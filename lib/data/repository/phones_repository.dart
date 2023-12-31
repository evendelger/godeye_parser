import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';

import 'package:godeye_parser/domain/domain.dart';
import 'package:godeye_parser/data/data.dart';

class PhonesDataRepository implements AbstractPhonesDataRepository {
  const PhonesDataRepository({
    required this.dataProvider,
    required this.phonesService,
  });

  final DataProvider dataProvider;
  final PhonesService phonesService;

  static const differenceInYears = 5;
  static final datePattern = RegExp(r'\d{2}\.\d{2}\.\d{4}');
  static final phonePattern = RegExp(r'(7|8)9\d{9}');

  List<String> _getPhonesFromBlock(Element blockInfoList) {
    final phoneList = <String>[];

    try {
      final phoneBlock = blockInfoList.children.firstWhere((e) =>
          e.children[0].text == "Телефоны:" ||
          e.children[0].text == "Телефон:");
      phoneList.addAll(phoneBlock.children[1].text.split(', ').where(
            (phone) =>
                phone.length == 11 && phone.startsWith('79') ||
                phone.startsWith('89'),
          ));
    } catch (e) {
      return phoneList;
    }
    return phoneList;
  }

  List<String> _getPhonesFromResultPage(List<SinglePersonModel> models) {
    final phoneList = <String>[];

    for (var model in models) {
      phoneList.addAll(model.phoneNumbersList);
    }

    return phoneList;
  }

  List<SinglePersonModel> _collectModels(List<Element> blocksDataList) {
    final personModels = <SinglePersonModel>[];
    final addedPhones = <String>{};
    final indexSubListFrom =
        blocksDataList[1].attributes['id'] == 'menuSvodka' ? 2 : 1;

    blocksDataList.sublist(indexSubListFrom).forEach((block) {
      final contentList = block.children[0].children[1];
      var blockModel = BlockFileInfoModel();
      for (var dataMap in contentList.children) {
        if (dataMap.children.length < 2) continue;
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
            title == "Домашинй адрес:" ||
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

    final indexToRemove = <int>[];

    for (int i = 0; i < personModels.length; i++) {
      final sameDateIndex = personModels.indexWhere(
        (model) =>
            model.dateOfBirth != null &&
            model.dateOfBirth == personModels[i].dateOfBirth,
        i + 1,
      );
      if (sameDateIndex != -1) {
        personModels[sameDateIndex]
            .adressesList
            .addAll(personModels[i].adressesList);
        personModels[sameDateIndex]
            .phoneNumbersList
            .addAll(personModels[i].phoneNumbersList);
        indexToRemove.add(i);
      }
    }
    personModels.retainWhere(
      (model) => !indexToRemove.contains(
        personModels.indexWhere((model2) => model2 == model),
      ),
    );

    return personModels;
  }

  Future<PersonFileModel> _exploreFile(String name) async {
    final data = await dataProvider.readPersonFile(name);
    if (data.isEmpty) return PersonFileModel.empty(name: '');

    final document = parser.parse(data);

    final blocksDataList =
        document.getElementsByClassName("result_search_page")[0].children;
    if (blocksDataList.last.children[0].className == 'blockItemRep') {
      final newBuggedList = blocksDataList.last.children.sublist(1);
      blocksDataList.addAll(newBuggedList);
    }

    final blockSummary =
        document.getElementById("menuSvodka")?.children[0].children[1];

    final modelsAfterSearching = _collectModels(blocksDataList);
    final allPhonesList = blockSummary == null
        ? _getPhonesFromResultPage(modelsAfterSearching)
        : _getPhonesFromBlock(blockSummary);

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
  List<String> searchByRegion(
    PersonFileModel model,
    String region,
  ) {
    final correctPhones = <String>[];

    for (int i = 0; i < model.allPhones!.length; i++) {
      final isCorrect = phonesService.checkRegion(model.allPhones![i], region);
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
          final foundedRCPhones =
              model.allPersonModels![i].phoneNumbersList.where(
            (phone) => model.stateModel.regionPhones!.contains(phone),
          );
          final setPhones =
              Set<String>.from(model.allPersonModels![i].phoneNumbersList);
          final foundedCityPhones =
              setPhones.difference(foundedRCPhones.toSet()).toList();
          cityRegionPhones.addAll(foundedRCPhones);
          cityPhones.addAll(foundedCityPhones);
        } else {
          final correctPhones = model.allPersonModels![i].phoneNumbersList;
          cityPhones.addAll(correctPhones);
        }
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
        if (model.stateModel.regionPhones == null) {
          experiencePhones.add({
            DateFormat('dd-MM-yyyy').format(singleModel.dateOfBirth!):
                singleModel.phoneNumbersList.toList()
          });
        } else {
          final expRegPhonesSet = singleModel.phoneNumbersList
              .where(
                (phone) => model.stateModel.regionPhones!.contains(phone),
              )
              .toSet();
          final setOfAllPhonesList =
              Set<String>.from(singleModel.phoneNumbersList);
          final expPhones =
              setOfAllPhonesList.difference(expRegPhonesSet).toList();

          if (expRegPhonesSet.isNotEmpty) {
            experienceRegionPhones.add({
              DateFormat('dd-MM-yyyy').format(singleModel.dateOfBirth!):
                  expRegPhonesSet.toList()
            });
          }
          if (expPhones.isNotEmpty) {
            experiencePhones.add({
              DateFormat('dd-MM-yyyy').format(singleModel.dateOfBirth!):
                  expPhones.toList()
            });
          }
        }
      }
    }

    return (experienceRegionPhones, experiencePhones);
  }

  @override
  (List<String>, List<String>) searchByText(
    String text,
    String region,
  ) {
    final List<String> correctedPhones = [];
    final List<String> allPhones = [];

    final matchedPhones = phonePattern.allMatches(text);
    for (var match in matchedPhones) {
      final phone = match.group(0);
      if (phone != null) {
        allPhones.add(phone);
        if (phonesService.checkRegion(phone, region)) {
          correctedPhones.add(phone);
        }
      }
    }

    return (correctedPhones, allPhones);
  }
}
