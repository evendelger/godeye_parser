import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_corrector/domain/data/regions_data.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/features/full_file_search/full_file_search.dart';
import 'package:phone_corrector/ui/widgets/widgets.dart';

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

class ListItem extends StatefulWidget {
  const ListItem({super.key, required this.index});

  final int index;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late final TextEditingController nameController;
  late final TextEditingController cityController;
  late final TextEditingController experienceController;

  @override
  void initState() {
    nameController = TextEditingController();
    cityController = TextEditingController();
    experienceController = TextEditingController();
    super.initState();

    final searchingDataItem =
        context.read<SearchingDataList>().listOfControllers[widget.index];
    nameController.text = searchingDataItem.nameControllerText;
    cityController.text = searchingDataItem.cityControllerText;
    experienceController.text = searchingDataItem.experienceControllerText;
  }

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RowIndex(index: widget.index),
          _TextFieldExample(
            width: 350,
            controller: nameController,
            hintText: 'Введите ФИО',
            parseType: ParseType.name,
            index: widget.index,
          ),
          const SizedBox(width: 10),
          _RowRegionSearch(index: widget.index),
          _RowCitySearch(
            cityController: cityController,
            index: widget.index,
          ),
          _RowExperienceSearch(
            experienceController: experienceController,
            index: widget.index,
          ),
          _RowIconsStatus(index: widget.index),
          const SizedBox(width: 10),
          _ClearButton(
            controllers: [nameController, cityController, experienceController],
            index: widget.index,
          ),
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
    context.read<FileSearchBloc>().add(ClearItem(index: index));
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
        Icons.delete,
        size: 35,
        color: Colors.red.shade400,
      ),
    );
  }
}

class _RowIconsStatus extends StatelessWidget {
  const _RowIconsStatus({
    super.key,
    required this.index,
  });

  final int index;

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
      child: BlocBuilder<FileSearchBloc, FileSearchState>(
        builder: (context, state) {
          final stateModel = state.models[index].stateModel;
          return Row(
            children: [
              _SingleIconStatus(
                icon: Icons.person,
                searchStatus: stateModel.regionStatus,
              ),
              _SingleIconStatus(
                icon: Icons.location_city,
                searchStatus: stateModel.cityStatus,
              ),
              _SingleIconStatus(
                icon: Icons.work,
                searchStatus: stateModel.experienceStatus,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SingleIconStatus extends StatelessWidget {
  const _SingleIconStatus({
    super.key,
    required this.icon,
    required this.searchStatus,
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
    final initialValue = context
        .read<SearchingDataList>()
        .listOfControllers[index]
        .regionToSearch;

    return Row(
      children: [
        DropDownListWidget(
          index: index,
          controller: TextEditingController(),
          typeOfProvider: TypeOfProvider.filesSearch,
          width: 312,
          height: 30,
          contentPadding: const EdgeInsets.only(bottom: 3, left: 30),
          fontSize: 19,
          overflow: TextOverflow.ellipsis,
          initialValue: initialValue.isEmpty ? null : initialValue,
        ),
        _SearchButton(searchType: SearchType.region, index: index),
        _ShowButton(searchType: SearchType.region, index: index),
      ],
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
          final parsedValue = int.tryParse(controller.text);
          if (parsedValue != null) {
            controllersModel.experienceControllerText = controller.text;
          }
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
    final bloc = context.read<FileSearchBloc>();

    switch (searchType) {
      case SearchType.region:
        {
          if (itemModel.regionToSearch.isEmpty ||
              bloc.state.models[index].stateModel.regionStatus ==
                  SearchStatus.inProgress) return;
        }
      case SearchType.city:
        {
          if (itemModel.cityControllerText.isEmpty ||
              bloc.state.models[index].stateModel.cityStatus ==
                  SearchStatus.inProgress) return;
        }
      case SearchType.experience:
        {
          if (itemModel.experienceControllerText.isEmpty ||
              bloc.state.models[index].stateModel.experienceStatus ==
                  SearchStatus.inProgress) return;
        }
    }

    switch (searchType) {
      case SearchType.region:
        bloc.add(SearchByRegion(
          index: index,
          name: itemModel.nameControllerText,
          region: DrowDownRegionsData.regionMap[itemModel.regionToSearch]!,
        ));
      case SearchType.city:
        bloc.add(SearchByCity(
          index: index,
          name: itemModel.nameControllerText,
          city: itemModel.cityControllerText,
        ));
      case SearchType.experience:
        bloc.add(SearchByExperience(
          index: index,
          name: itemModel.nameControllerText,
          experience: itemModel.experienceControllerText,
        ));
    }
    _showDialog(context, bloc);
  }

  void _showDialog(BuildContext context, FileSearchBloc bloc) {
    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider<FileSearchBloc>.value(
          value: bloc,
          child: _AlertDialog(searchType: searchType, index: index),
        );
      },
    );
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

  void _showDialog(BuildContext context) {
    final bloc = context.read<FileSearchBloc>();

    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider<FileSearchBloc>.value(
          value: bloc,
          child: _AlertDialog(searchType: searchType, index: index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showDialog(context),
      icon: const Icon(
        Icons.description,
        color: Colors.black,
      ),
    );
  }
}

class _AlertDialog extends StatelessWidget {
  const _AlertDialog({
    super.key,
    required this.searchType,
    required this.index,
  });

  final int index;
  final SearchType searchType;

  Widget _switchSearchType(PersonFileModel model) {
    switch (searchType) {
      case SearchType.region:
        return _switchRegionStatus(model);
      case SearchType.city:
        return _switchCityStatus(model);
      case SearchType.experience:
        return _switchExperienceStatus(model);
    }
  }

  Widget _switchRegionStatus(PersonFileModel model) {
    switch (model.stateModel.regionStatus) {
      case SearchStatus.waiting:
        return _textMessage('Начните поиск');
      case SearchStatus.inProgress:
        return _progressIndicator();
      case SearchStatus.success:
        return RegionInfoWidget(
          regionPhones: model.stateModel.regionPhones!,
          allPhones: model.allPhones!,
        );
      case SearchStatus.error:
        return _textMessage('Ошибка, повторите попытку');
    }
  }

  Widget _switchCityStatus(PersonFileModel model) {
    switch (model.stateModel.cityStatus) {
      case SearchStatus.waiting:
        return _textMessage('Начните поиск');
      case SearchStatus.inProgress:
        return _progressIndicator();
      case SearchStatus.success:
        return _cityInfo(model);
      case SearchStatus.error:
        return _textMessage('Ошибка, повторите попытку');
    }
  }

  Widget _switchExperienceStatus(PersonFileModel model) {
    switch (model.stateModel.experienceStatus) {
      case SearchStatus.waiting:
        return _textMessage('Начните поиск');
      case SearchStatus.inProgress:
        return _progressIndicator();
      case SearchStatus.success:
        return _experienceInfo(model);
      case SearchStatus.error:
        return _textMessage('Ошибка, повторите попытку');
    }
  }

  List<Widget> _title(ThemeData theme, FileSearchState state) {
    String getFullRegion(String shortRegion) {
      const map = DrowDownRegionsData.regionMap;
      return map.keys.firstWhere(
        (key) => map[key] == shortRegion,
        orElse: () => 'ОШИБКА',
      );
    }

    return [
      Text(
        'Найденные телефоны',
        style: theme.textTheme.titleMedium,
      ),
      state.models[index].name.isEmpty
          ? const SizedBox.shrink()
          : Text(
              state.models[index].name,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColor.withOpacity(0.9),
                letterSpacing: 0.1,
              ),
            ),
      state.models[index].stateModel.regionToSearch == null
          ? const SizedBox.shrink()
          : Text(
              getFullRegion(state.models[index].stateModel.regionToSearch!),
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 20,
                color: theme.primaryColor.withOpacity(0.8),
                letterSpacing: 0.1,
              ),
            ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<FileSearchBloc, FileSearchState>(
      builder: (context, state) {
        return AlertDialog(
          title: Column(
            children: _title(theme, state),
          ),
          content: SizedBox(
            height: 600,
            width: 600,
            child: _switchSearchType(state.models[index]),
          ),
        );
      },
    );
  }

  Center _progressIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Center _textMessage(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  ListView _cityInfo(PersonFileModel model) {
    return ListView(
      children: [
        Row(
          children: [
            const SizedBox(width: 30),
            _summaryInfoBlock(
              'Город и Регион',
              model.stateModel.cityRegionPhones!,
              Colors.green.shade700,
            ),
            const SizedBox(width: 30),
            _summaryInfoBlock(
              'Город',
              model.stateModel.cityPhones!,
              Colors.pink,
            ),
            const SizedBox(width: 100),
            _summaryInfoBlock(
              'Всего',
              model.allPhones!,
              Colors.black87,
            ),
          ],
        ),
        const SizedBox(height: 30),
        _allInfoBlock(
          'Город и регион',
          model.stateModel.cityRegionPhones!,
          Colors.green.shade700,
        ),
        const SizedBox(height: 10),
        _allInfoBlock(
          'Город',
          model.stateModel.cityPhones!,
          Colors.pink,
        ),
        const SizedBox(height: 10),
        _allInfoBlock(
          'Всего',
          model.allPhones!,
          Colors.black87,
        ),
      ],
    );
  }

  ListView _experienceInfo(PersonFileModel model) {
    return ListView(
      children: [
        Row(
          children: [
            const SizedBox(width: 30),
            _summaryInfoBlock(
              'Стаж и Регион',
              model.stateModel.experienceRegionPhones!
                  .map((e) => e.values.expand((x) => x))
                  .expand((x) => x)
                  .toList(),
              Colors.green.shade700,
            ),
            const SizedBox(width: 30),
            _summaryInfoBlock(
              'Стаж',
              model.stateModel.experiencePhones!
                  .map((e) => e.values.expand((x) => x))
                  .expand((x) => x)
                  .toList(),
              Colors.pink,
            ),
            const SizedBox(width: 100),
            _summaryInfoBlock(
              'Всего',
              model.allPhones!,
              Colors.black87,
            ),
          ],
        ),
        const SizedBox(height: 30),
        _allInfoBlock(
          'Стаж и регион',
          model.stateModel.experienceRegionPhones!,
          Colors.green.shade700,
          model.stateModel.experienceToSearch,
        ),
        const SizedBox(height: 10),
        _allInfoBlock(
          'Стаж',
          model.stateModel.experiencePhones!,
          Colors.pink,
          model.stateModel.experienceToSearch,
        ),
        const SizedBox(height: 10),
        _allInfoBlock('Всего', model.allPhones!, Colors.black87),
      ],
    );
  }

  int parseSubstring(String line) => int.parse(line.substring(6, 10));

  Column _allInfoBlock(
    String title,
    List content,
    Color color, [
    String? experienceToSearch,
  ]) {
    final textStyle = TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: color,
    );

    InkWell phoneCopyableText(String phone, [Color? newColor]) {
      return InkWell(
        onTap: () async => await Clipboard.setData(ClipboardData(text: phone)),
        overlayColor: MaterialStatePropertyAll(color.withOpacity(0.07)),
        child: Text(
          phone,
          style: textStyle.copyWith(color: newColor),
        ),
      );
    }

    List<Widget> listOfPhones([List? newContent, Color? newColor]) {
      if (newContent != null) {
        return List<Widget>.generate(newContent.length,
            (i) => phoneCopyableText(newContent[i], newColor));
      }
      return List<Widget>.generate(
          content.length, (i) => phoneCopyableText(content[i]));
    }

    const greenColorsMap = {
      0: Color(0xFF388E3C),
      1: Color(0xFF317E35),
      2: Color(0xFF2A6D2D),
      3: Color(0xFF245D26),
      4: Color(0xFF1D4D1F),
      5: Color(0xFF163C17),
    };

    const redColorsMap = {
      0: Color(0xFFE91E63),
      1: Color(0xFFD51C5B),
      2: Color(0xFFC11952),
      3: Color(0xFFAE174A),
      4: Color(0xFF9A1542),
      5: Color(0xFF861239),
    };

    List<Row> listOfMappedPhones() {
      const int trueDiff = 5;
      final rowMap = <String, List<String>>{};

      for (var element in (content as List<Map<String, List<String>>>)) {
        final date = element.keys.first;
        final difference = (DateTime.now().year -
                (parseSubstring(date) + int.parse(experienceToSearch!) + 23))
            .abs();
        if (difference <= trueDiff) {
          rowMap[date] = element.values.toList()[0];
        }
      }
      if (rowMap.isEmpty) return List<Row>.empty();

      return List<Row>.generate(rowMap.length, (index) {
        final key = rowMap.keys.toList()[index];
        final values = rowMap.values.toList()[index];
        final diff = (DateTime.now().year -
                (parseSubstring(key) + int.parse(experienceToSearch!) + 23))
            .abs();
        final mappedColor = color == Colors.green.shade700
            ? greenColorsMap[diff]
            : redColorsMap[diff];

        return Row(
          children: [
            Text(
              '$key - ',
              style: textStyle.copyWith(color: mappedColor),
            ),
            Wrap(
              spacing: 10,
              children: listOfPhones(values, mappedColor),
            ),
          ],
        );
      });
    }

    return Column(
      children: [
        Text(
          title,
          style: textStyle,
        ),
        const SizedBox(height: 10),
        content.isEmpty
            ? Text(
                'Пусто',
                style: textStyle.copyWith(fontSize: 14),
              )
            : Wrap(
                spacing: 10,
                children: experienceToSearch != null
                    ? listOfMappedPhones()
                    : listOfPhones(),
              ),
      ],
    );
  }

  Column _summaryInfoBlock(String title, List list, Color color) {
    Future<void> copyText() async {
      final length = list.length >= 3 ? 3 : list.length;
      final toCopy = [];

      for (int i = 0; i < length; i++) {
        toCopy.add(list[i]);
      }
      await Clipboard.setData(ClipboardData(text: toCopy.join('\t')));
    }

    final textStyle = TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: color,
    );

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: textStyle,
        ),
        Text(
          list.length.toString(),
          style: textStyle.copyWith(fontSize: 44),
        ),
        FilledButton(
          onPressed: copyText,
          child: const Icon(Icons.copy),
        ),
      ],
    );
  }
}
