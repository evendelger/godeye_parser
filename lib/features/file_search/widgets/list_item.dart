import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_corrector/domain/data/regions_data.dart';
import 'package:phone_corrector/domain/provider_models/provider_models.dart';
import 'package:phone_corrector/features/file_search/bloc/files_bloc.dart';
import 'package:phone_corrector/ui/widgets/widgets.dart';

typedef ExampleModel = String;

enum ParseType {
  name,
  city,
  experience,
}

enum SearchType {
  region,
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
  // 0 - name, 1 - city, 2 - experience
  late final List<TextEditingController> controllers;

  @override
  void initState() {
    controllers = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];
    super.initState();
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
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
            controller: controllers[0],
            hintText: 'Введите ФИО',
            parseType: ParseType.name,
            index: widget.index,
          ),
          const SizedBox(width: 10),
          _RowRegionSearch(index: widget.index),
          _RowCitySearch(
            cityController: controllers[1],
            index: widget.index,
          ),
          _RowExperienceSearch(
            experienceController: controllers[2],
            index: widget.index,
          ),
          const _RowIconsStatus(),
          const SizedBox(width: 10),
          _ClearButton(controllers: controllers, index: widget.index),
        ],
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({
    super.key,
    required this.controllers,
    required this.index,
  });

  final List<TextEditingController> controllers;
  final int index;

  void _clearItem(BuildContext context, int index) {
    context.read<FilesBloc>().add(ClearItem(index: index));
    for (var c in controllers) {
      c.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _clearItem(context, index),
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.clear_all,
        size: 35,
        color: Colors.red.shade400,
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
    required this.icon,
    this.searchStatus = SearchStatus.waiting,
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
  const _RowExperienceSearch({
    super.key,
    required this.experienceController,
    required this.index,
  });

  final TextEditingController experienceController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TextFieldExample(
          width: 110,
          controller: experienceController,
          hintText: 'Стаж',
          parseType: ParseType.experience,
          index: index,
        ),
        _SearchButton(searchType: SearchType.experience, index: index),
        _ShowButton(searchType: SearchType.experience, index: index),
      ],
    );
  }
}

class _RowCitySearch extends StatelessWidget {
  const _RowCitySearch({
    super.key,
    required this.cityController,
    required this.index,
  });

  final TextEditingController cityController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TextFieldExample(
          width: 175,
          controller: cityController,
          hintText: 'Введите город',
          parseType: ParseType.city,
          index: index,
        ),
        _SearchButton(searchType: SearchType.city, index: index),
        _ShowButton(searchType: SearchType.city, index: index),
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
  const _RowRegionSearch({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DropDownListWidget(index: index),
        _SearchButton(searchType: SearchType.region, index: index),
        _ShowButton(searchType: SearchType.region, index: index),
      ],
    );
  }
}

class _DropDownListWidget extends StatelessWidget {
  const _DropDownListWidget({super.key, required this.index});

  final int index;

  void _saveSelectedRegion(BuildContext context, String? value) {
    if (value != null) {
      context
          .read<SearchingDataList>()
          .listOfControllers[index]
          .regionToSearch = value;
    }
  }

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
        onChanged: (value) => _saveSelectedRegion(context, value),
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
    required this.index,
  });

  final double width;
  final String hintText;
  final TextEditingController controller;
  final ParseType parseType;
  final int index;

  Future<void> _getAndFormatText(BuildContext context) async {
    final cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata == null || cdata.text == null) return;

    switch (parseType) {
      case ParseType.name:
        {
          final text = cdata.text!.trim();
          controller.text = text;

          if (context.mounted) {
            _saveControllerValue(context, text);
          }
        }
      case ParseType.city:
        {
          final trimmedText = cdata.text!.trim();
          final indexOfSpace = trimmedText.lastIndexOf(' ');
          final text = indexOfSpace != -1
              ? trimmedText.substring(0, indexOfSpace)
              : trimmedText;
          controller.text = text;

          if (context.mounted) {
            _saveControllerValue(context, text);
          }
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

          if (context.mounted) {
            _saveControllerValue(context, parsedText.toString());
          }
        }
    }
  }

  void _saveControllerValue(BuildContext context, String value) {
    final controllersModel =
        context.read<SearchingDataList>().listOfControllers[index];
    switch (parseType) {
      case ParseType.name:
        {
          controllersModel.nameControllerText = controller.text;
        }
      case ParseType.city:
        {
          controllersModel.cityControllerText = controller.text;
        }
      case ParseType.experience:
        {
          controllersModel.experienceControllerText = controller.text;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        onChanged: (value) => _saveControllerValue(context, value),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
          isDense: true,
          suffixIcon: CupertinoButton(
            onPressed: () => _getAndFormatText(context),
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
  const _SearchButton(
      {super.key, required this.searchType, required this.index});

  final SearchType searchType;
  final int index;

  void _search(BuildContext context) {
    final itemModel =
        context.read<SearchingDataList>().listOfControllers[index];
    if (itemModel.regionToSearch.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(messageSnackbar);
    }

    final bloc = context.read<FilesBloc>();

    switch (searchType) {
      case SearchType.region:
        bloc.add(SearchByRegion(
          index: index,
          name: itemModel.nameControllerText,
          region: itemModel.regionToSearch,
        ));

      case SearchType.city:
      //  bloc.add(event);
      case SearchType.experience:
      //  bloc.add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _search(context),
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.search,
        color: Colors.black,
      ),
    );
  }
}

class _ShowButton extends StatelessWidget {
  const _ShowButton({
    super.key,
    required this.searchType,
    required this.index,
  });

  final SearchType searchType;
  final int index;

  Future<void> _showDialog(BuildContext context) async {
    final stateModel = context.read<FilesBloc>().state.models[index].stateModel;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'Найденные телефоны',
            style: Theme.of(context).textTheme.titleMedium,
          )),
          content: SizedBox(
            width: 600,
            height: 600,
            child: searchType == SearchType.region
                ? Center(child: Text(stateModel.regionPhones.toString()))
                : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () async => _showDialog(context),
      icon: const Icon(
        Icons.description,
        color: Colors.black,
      ),
    );
  }
}
