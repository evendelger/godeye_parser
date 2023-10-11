import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegionInfoWidget extends StatelessWidget {
  const RegionInfoWidget({
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
              Colors.green.shade700,
            ),
            _summaryInfoBlock(
              'Всего',
              allPhones,
              Colors.black87,
            ),
          ],
        ),
        const SizedBox(height: 30),
        _allInfoBlock(
          'Регион',
          regionPhones,
          Colors.green.shade700,
        ),
        const SizedBox(height: 10),
        _allInfoBlock(
          'Всего',
          allPhones,
          Colors.black87,
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

  Column _allInfoBlock(String title, List content, Color color) {
    final textStyle = TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: color,
    );

    InkWell phoneCopyableText(String phone) {
      return InkWell(
        onTap: () async => await Clipboard.setData(ClipboardData(text: phone)),
        overlayColor: MaterialStatePropertyAll(color.withOpacity(0.07)),
        child: Text(
          phone,
          style: textStyle,
        ),
      );
    }

    List<Widget> listOfPhones() {
      return List<Widget>.generate(
          content.length, (i) => phoneCopyableText(content[i]));
    }

    return Column(
      children: [
        Text(title, style: textStyle),
        const SizedBox(height: 10),
        content.isEmpty
            ? Text(
                'Пусто',
                style: textStyle.copyWith(fontSize: 14),
              )
            : Wrap(
                spacing: 10,
                children: listOfPhones(),
              ),
      ],
    );
  }
}
