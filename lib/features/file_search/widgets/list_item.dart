import 'dart:developer';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_corrector/domain/api/api.dart';
import 'package:phone_corrector/domain/data/regions_data.dart';
import 'package:phone_corrector/repositories/phones_repository.dart';

typedef ExampleModel = String;

enum ParseType {
  name,
  city,
  experience,
}

enum SearchStatus {
  waiting,
  inProgress,
  success,
  error,
}

class ListItem extends StatefulWidget {
  const ListItem({super.key, required this.index});

  final int index;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _experienceController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _cityController = TextEditingController();
    _experienceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RowIndex(index: widget.index),
          _TextFieldExample(
            width: 400,
            controller: _nameController,
            hintText: 'Введите ФИО',
            parseType: ParseType.name,
          ),
          const SizedBox(width: 10),
          const _RowRegionSearch(),
          _RowCitySearch(cityController: _cityController),
          _RowExperienceSearch(experienceController: _experienceController),
          const _RowIconsStatus(),
          const SizedBox(width: 10),
          const _DeleteButton(),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => log('удаление строки'),
      padding: EdgeInsets.zero,
      child: const Icon(
        Icons.delete,
        size: 35,
        color: Colors.red,
      ),
    );
  }
}

class _RowIconsStatus extends StatelessWidget {
  const _RowIconsStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black12,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: const Row(
        children: [
          _SingleIconStatus(icon: Icons.person),
          _SingleIconStatus(icon: Icons.location_city),
          _SingleIconStatus(icon: Icons.work),
        ],
      ),
    );
  }
}

class _SingleIconStatus extends StatelessWidget {
  const _SingleIconStatus({
    super.key,
    this.searchStatus = SearchStatus.waiting,
    required this.icon,
  });

  final IconData icon;
  final SearchStatus searchStatus;

  Color _getColor() {
    switch (searchStatus) {
      case SearchStatus.waiting:
        return Colors.black;
      case SearchStatus.inProgress:
        return Colors.yellow.shade800;
      case SearchStatus.success:
        return Colors.greenAccent.shade700;
      case SearchStatus.error:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: _getColor(),
      size: 35,
    );
  }
}

class _RowExperienceSearch extends StatelessWidget {
  const _RowExperienceSearch({super.key, required this.experienceController});

  final TextEditingController experienceController;

  void _searchByExperience() => log('Поиск по опыту...');

  void _showExperienceInfo() => log('номера по стажу...');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TextFieldExample(
          width: 110,
          controller: experienceController,
          hintText: 'Стаж',
          parseType: ParseType.experience,
        ),
        _SearchButton(onPressed: _searchByExperience),
        const _ShowButton(model: 'Модель опыта'),
      ],
    );
  }
}

class _RowCitySearch extends StatelessWidget {
  const _RowCitySearch({super.key, required this.cityController});

  final TextEditingController cityController;

  void _searchByCity() => log('поиск по городу...');

  void _showCityInfo() =>
      log('Показываю окно найденных телефонов по городу...');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TextFieldExample(
          width: 175,
          controller: cityController,
          hintText: 'Введите город',
          parseType: ParseType.city,
        ),
        _SearchButton(onPressed: _searchByCity),
        const _ShowButton(model: 'Модель города'),
      ],
    );
  }
}

class _RowIndex extends StatelessWidget {
  const _RowIndex({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF364091).withOpacity(0.25),
        border: Border.all(width: 1, color: Colors.black.withOpacity(0.5)),
      ),
      child: Text(
        '${index + 1}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }
}

class _RowRegionSearch extends StatelessWidget {
  const _RowRegionSearch({super.key});

  void _searchByRegion() => log('поиск по региону...');

  void _showRegionInfo() =>
      log('Показываю окно найденных телефонов по региону...');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _DropDownListWidget(),
        _SearchButton(onPressed: _searchByRegion),
        const _ShowButton(model: 'Модель региона'),
      ],
    );
  }
}

class _DropDownListWidget extends StatelessWidget {
  const _DropDownListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 30,
      child: DropdownSearch<String>(
        dropdownButtonProps: const DropdownButtonProps(isVisible: false),
        popupProps: PopupProps.dialog(
          showSearchBox: true,
          searchDelay: Duration.zero,
          // TODO: причесать окно поиска
          emptyBuilder: (context, searchEntry) {
            return const Center(child: Text('Ничего не найдено'));
          },
        ),
        items: DrowDownRegionsData.regions,
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          baseStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            overflow: TextOverflow.ellipsis,
          ),
          dropdownSearchDecoration: InputDecoration(
            isDense: true,
            hintText: "Выбрать регион",
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
            contentPadding: const EdgeInsets.only(bottom: 3, left: 30),
            isCollapsed: true,
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
        selectedItem: null,
      ),
    );
  }
}

class _TextFieldExample extends StatelessWidget {
  const _TextFieldExample({
    super.key,
    required this.width,
    required this.controller,
    required this.hintText,
    required this.parseType,
  });

  final double width;
  final String hintText;
  final TextEditingController controller;
  final ParseType parseType;

  Future<void> _getAndFormatText() async {
    final cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata == null || cdata.text == null) return;

    switch (parseType) {
      case ParseType.name:
        {
          final text = cdata.text!.trim();
          controller.text = text;
        }
      case ParseType.city:
        {
          final trimmedText = cdata.text!.trim();
          final indexOfSpace = trimmedText.lastIndexOf(' ');
          final text = indexOfSpace != -1
              ? trimmedText.substring(0, indexOfSpace)
              : trimmedText;
          controller.text = text;
        }
      case ParseType.experience:
        {
          final parsedText = StringBuffer();
          for (int i = 0; i < cdata.text!.length; i++) {
            final symbol = cdata.text![i];
            if (int.tryParse(symbol) != null) {
              parsedText.write(symbol);
            }
          }
          controller.text = parsedText.toString().isNotEmpty
              ? parsedText.toString()
              : controller.text;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
          isDense: true,
          suffixIcon: CupertinoButton(
            onPressed: _getAndFormatText,
            child: const Icon(Icons.paste, size: 20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFF364091),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () async {
        final repo =
            PhonesDataRepository(apiClient: VoxlinkApiClient(dio: Dio()));
        final model = await repo.getDataFromFile("Белова Надежда Анатольевна");
        print(model.allPersonModels.length);
      },
      padding: EdgeInsets.zero,
      child: const Icon(
        Icons.search,
        color: Colors.black,
      ),
    );
  }
}

class _ShowButton extends StatelessWidget {
  const _ShowButton({super.key, required this.model});

  final ExampleModel model;

  Future<void> _showDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'Найденные телефоны',
            style: Theme.of(context).textTheme.titleMedium,
          )),
          content: const SizedBox(
            width: 500,
            height: 500,
            child: Center(child: Text('контент')),
          ),
          actions: [
            FilledButton(
              onPressed: () => log('скопировал первые 3 телефона...'),
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                  EdgeInsets.only(bottom: 13, left: 25, right: 25, top: 5),
                ),
              ),
              child: const Text(
                'Скопировать первые 3 номера',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () async => _showDialog(context),
      child: const Icon(
        Icons.description,
        color: Colors.black,
      ),
    );
  }
}
