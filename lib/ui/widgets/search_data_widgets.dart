import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:godeye_parser/domain/domain.dart';
import 'package:godeye_parser/ui/theme/theme.dart';

class SearchEmpty extends StatelessWidget {
  const SearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CustomTextMesageWidget(text: 'Поиск не выполнен');
  }
}

class SearchInProgress extends StatelessWidget {
  const SearchInProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class SearchFailed extends StatelessWidget {
  const SearchFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CustomTextMesageWidget(text: 'Файл не найден, проверьте ФИО');
  }
}

class _CustomTextMesageWidget extends StatelessWidget {
  const _CustomTextMesageWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        text,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

class SearchSuccessRegion extends StatelessWidget {
  const SearchSuccessRegion({
    super.key,
    required this.isFullScreen,
    required this.regionPhones,
    required this.allPhones,
  });

  final bool isFullScreen;
  final List<String> regionPhones;
  final List<String> allPhones;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _summaryInfoBlock(
              isFullScreen,
              'Регион',
              regionPhones,
              ColorsList.dataGreenColor,
            ),
            _summaryInfoBlock(
              isFullScreen,
              'Всего',
              allPhones,
              ColorsList.dataBlackColor,
            ),
          ],
        ),
        SizedBox(height: isFullScreen ? 30 : 10),
        _allInfoBlock(
          isFullScreen,
          'Регион',
          regionPhones,
          ColorsList.dataGreenColor,
        ),
        SizedBox(height: isFullScreen ? 10 : 5),
        _allInfoBlock(
          isFullScreen,
          'Всего',
          allPhones,
          ColorsList.dataBlackColor,
        ),
        SizedBox(height: isFullScreen ? 10 : 5),
      ],
    );
  }
}

class SearchSuccessCity extends StatelessWidget {
  const SearchSuccessCity({
    super.key,
    required this.isFullScreen,
    required this.cityRegionPhones,
    required this.cityPhones,
    required this.allPhones,
  });

  final bool isFullScreen;
  final List<String> cityRegionPhones;
  final List<String> cityPhones;
  final List<String> allPhones;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _summaryInfoBlock(
              isFullScreen,
              'Город и Регион',
              cityRegionPhones,
              ColorsList.dataGreenColor,
            ),
            _summaryInfoBlock(
              isFullScreen,
              'Город',
              cityPhones,
              ColorsList.dataPinkColor,
            ),
            _summaryInfoBlock(
              isFullScreen,
              'Всего',
              allPhones,
              ColorsList.dataBlackColor,
            ),
          ],
        ),
        SizedBox(height: isFullScreen ? 30 : 10),
        _allInfoBlock(
          isFullScreen,
          'Город и регион',
          cityRegionPhones,
          ColorsList.dataGreenColor,
        ),
        SizedBox(height: isFullScreen ? 10 : 5),
        _allInfoBlock(
          isFullScreen,
          'Город',
          cityPhones,
          ColorsList.dataPinkColor,
        ),
        SizedBox(height: isFullScreen ? 10 : 5),
        _allInfoBlock(
          isFullScreen,
          'Всего',
          allPhones,
          ColorsList.dataBlackColor,
        ),
      ],
    );
  }
}

class SearchSuccessExperience extends StatelessWidget {
  const SearchSuccessExperience({
    super.key,
    required this.isFullScreen,
    required this.experienceToSearch,
    required this.experienceRegionPhones,
    required this.experiencePhones,
    required this.allPhones,
    required this.phonesWithoutDate,
    required this.regionPhonesWithoutDate,
  });

  final bool isFullScreen;
  final String experienceToSearch;
  final MapList experienceRegionPhones;
  final MapList experiencePhones;
  final List<String> allPhones;
  final List<String> phonesWithoutDate;
  final List<String> regionPhonesWithoutDate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _summaryInfoBlock(
              isFullScreen,
              'Стаж и Регион',
              experienceRegionPhones
                  .map((e) => e.values.expand((x) => x))
                  .expand((x) => x)
                  .toList(),
              ColorsList.dataGreenColor,
            ),
            _summaryInfoBlock(
              isFullScreen,
              'Стаж',
              experiencePhones
                  .map((e) => e.values.expand((x) => x))
                  .expand((x) => x)
                  .toList(),
              ColorsList.dataPinkColor,
            ),
            _summaryInfoBlock(
              isFullScreen,
              'Регион без даты',
              regionPhonesWithoutDate,
              ColorsList.dataBlueColor,
            ),
            _summaryInfoBlock(
              isFullScreen,
              'Без даты',
              phonesWithoutDate,
              ColorsList.dataOrangeColor,
            ),
            _summaryInfoBlock(
              isFullScreen,
              'Всего',
              allPhones,
              ColorsList.dataBlackColor,
            ),
          ],
        ),
        SizedBox(height: isFullScreen ? 30 : 10),
        _allInfoBlock(
          isFullScreen,
          'Стаж и регион',
          experienceRegionPhones,
          ColorsList.dataGreenColor,
          experienceToSearch,
        ),
        SizedBox(height: isFullScreen ? 10 : 5),
        _allInfoBlock(
          isFullScreen,
          'Стаж',
          experiencePhones,
          ColorsList.dataPinkColor,
          experienceToSearch,
        ),
        SizedBox(height: isFullScreen ? 10 : 5),
        _allInfoBlock(
          isFullScreen,
          'Регион без даты',
          regionPhonesWithoutDate,
          ColorsList.dataBlueColor,
        ),
        SizedBox(height: isFullScreen ? 10 : 5),
        _allInfoBlock(
          isFullScreen,
          'Без даты',
          phonesWithoutDate,
          ColorsList.dataOrangeColor,
        ),
        SizedBox(height: isFullScreen ? 10 : 5),
        _allInfoBlock(
          isFullScreen,
          'Всего',
          allPhones,
          ColorsList.dataBlackColor,
        ),
        SizedBox(height: isFullScreen ? 10 : 5),
      ],
    );
  }
}

int _parseSubstring(String line) => int.parse(line.substring(6, 10));

Column _summaryInfoBlock(
    bool isFullScreen, String title, List list, Color color) {
  Future<void> copyText() async {
    final length = list.length >= 3 ? 3 : list.length;
    final toCopy = [];

    for (int i = 0; i < length; i++) {
      toCopy.add(list[i]);
    }
    await Clipboard.setData(ClipboardData(text: toCopy.join('\t')));
  }

  final textStyle = TextStyle(
    fontSize: isFullScreen ? 21 : 13,
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
        style: textStyle.copyWith(fontSize: isFullScreen ? 44 : 30),
      ),
      FilledButton(
        onPressed: copyText,
        style: isFullScreen
            ? null
            : const ButtonStyle(
                iconSize: MaterialStatePropertyAll(20),
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
              ),
        child: const Icon(Icons.copy),
      ),
    ],
  );
}

Column _allInfoBlock(
  bool isFullScreen,
  String title,
  List content,
  Color color, [
  String? experienceToSearch,
]) {
  final textStyle = TextStyle(
    fontSize: isFullScreen ? 21 : 19,
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
      return List<Widget>.generate(
          newContent.length, (i) => phoneCopyableText(newContent[i], newColor));
    }
    return List<Widget>.generate(
        content.length, (i) => phoneCopyableText(content[i]));
  }

  List<SizedBox> listOfMappedPhones() {
    const int trueDiff = 5;
    final rowMap = <String, List<String>>{};

    for (var element in (content as List<Map<String, List<String>>>)) {
      final date = element.keys.first;
      final difference = (DateTime.now().year -
              (_parseSubstring(date) + int.parse(experienceToSearch!) + 23))
          .abs();
      if (difference <= trueDiff) {
        rowMap[date] = element.values.toList()[0];
      }
    }
    if (rowMap.isEmpty) return List<SizedBox>.empty();

    return List<SizedBox>.generate(rowMap.length, (index) {
      final key = rowMap.keys.toList()[index];
      final values = rowMap.values.toList()[index];
      final diff = (DateTime.now().year -
              (_parseSubstring(key) + int.parse(experienceToSearch!) + 23))
          .abs();
      final mappedColor = color == ColorsList.dataGreenColor
          ? ColorsList.greenColorsMap[diff]
          : ColorsList.redColorsMap[diff];

      return SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$key - ',
              style: textStyle.copyWith(color: mappedColor),
            ),
            Flexible(
              child: Wrap(
                runAlignment: WrapAlignment.center,
                spacing: 10,
                children: listOfPhones(values, mappedColor),
              ),
            ),
          ],
        ),
      );
    });
  }

  return Column(
    children: [
      Text(
        title,
        style: textStyle,
      ),
      SizedBox(height: isFullScreen ? 10 : 5),
      content.isEmpty
          ? Text(
              'Пусто',
              style: textStyle.copyWith(fontSize: 14),
            )
          : experienceToSearch != null
              ? Column(children: listOfMappedPhones())
              : Wrap(
                  spacing: 10,
                  children: listOfPhones(),
                ),
    ],
  );
}
