import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_corrector/domain/models/models.dart';

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

final greenColor = Colors.green.shade700;
const blackColor = Colors.black87;
const pinkColor = Colors.pink;

class SearchInitial extends StatelessWidget {
  const SearchInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CustomTextMesageWidget(text: 'Начните поиск');
  }
}

class SearchInProgress extends StatelessWidget {
  const SearchInProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
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
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class SearchSuccessRegion extends StatelessWidget {
  const SearchSuccessRegion({
    super.key,
    required this.regionPhones,
    required this.allPhones,
  });

  final List<String> regionPhones;
  final List<String> allPhones;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _summaryInfoBlock(
              'Регион',
              regionPhones,
              greenColor,
            ),
            _summaryInfoBlock(
              'Всего',
              allPhones,
              blackColor,
            ),
          ],
        ),
        const SizedBox(height: 5),
        _allInfoBlock(
          'Регион',
          regionPhones,
          greenColor,
        ),
        const SizedBox(height: 5),
        _allInfoBlock(
          'Всего',
          allPhones,
          blackColor,
        ),
      ],
    );
  }
}

class SearchSuccessCity extends StatelessWidget {
  const SearchSuccessCity({
    super.key,
    required this.cityRegionPhones,
    required this.cityPhones,
    required this.allPhones,
  });

  final List<String> cityRegionPhones;
  final List<String> cityPhones;
  final List<String> allPhones;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _summaryInfoBlock(
              'Город и Регион',
              cityRegionPhones,
              greenColor,
            ),
            _summaryInfoBlock(
              'Город',
              cityPhones,
              pinkColor,
            ),
            _summaryInfoBlock(
              'Всего',
              allPhones,
              blackColor,
            ),
          ],
        ),
        const SizedBox(height: 5),
        _allInfoBlock(
          'Город и регион',
          cityRegionPhones,
          greenColor,
        ),
        const SizedBox(height: 5),
        _allInfoBlock(
          'Город',
          cityPhones,
          pinkColor,
        ),
        const SizedBox(height: 5),
        _allInfoBlock(
          'Всего',
          allPhones,
          blackColor,
        ),
      ],
    );
  }
}

class SearchSuccessExperience extends StatelessWidget {
  const SearchSuccessExperience({
    super.key,
    required this.experienceToSearch,
    required this.experienceRegionPhones,
    required this.experiencePhones,
    required this.allPhones,
  });

  final String experienceToSearch;
  final MapList experienceRegionPhones;
  final MapList experiencePhones;
  final List<String> allPhones;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _summaryInfoBlock(
              'Стаж и Регион',
              experienceRegionPhones
                  .map((e) => e.values.expand((x) => x))
                  .expand((x) => x)
                  .toList(),
              greenColor,
            ),
            _summaryInfoBlock(
              'Стаж',
              experiencePhones
                  .map((e) => e.values.expand((x) => x))
                  .expand((x) => x)
                  .toList(),
              pinkColor,
            ),
            _summaryInfoBlock(
              'Всего',
              allPhones,
              blackColor,
            ),
          ],
        ),
        const SizedBox(height: 30),
        _allInfoBlock(
          'Стаж и регион',
          experienceRegionPhones,
          greenColor,
          experienceToSearch,
        ),
        const SizedBox(height: 10),
        _allInfoBlock(
          'Стаж',
          experiencePhones,
          pinkColor,
          experienceToSearch,
        ),
        const SizedBox(height: 10),
        _allInfoBlock(
          'Всего',
          allPhones,
          blackColor,
        ),
      ],
    );
  }
}

int parseSubstring(String line) => int.parse(line.substring(6, 10));

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
    fontSize: 15,
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
        style: textStyle.copyWith(fontSize: 30),
      ),
      FilledButton(
        onPressed: copyText,
        style: const ButtonStyle(
          iconSize: MaterialStatePropertyAll(20),
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
        ),
        child: const Icon(Icons.copy),
      ),
    ],
  );
}

Column _allInfoBlock(
  String title,
  List content,
  Color color, [
  String? experienceToSearch,
]) {
  final textStyle = TextStyle(
    fontSize: 19,
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
              (parseSubstring(date) + int.parse(experienceToSearch!) + 23))
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
              (parseSubstring(key) + int.parse(experienceToSearch!) + 23))
          .abs();
      final mappedColor = color == Colors.green.shade700
          ? greenColorsMap[diff]
          : redColorsMap[diff];

      return SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
