import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:godeye_parser/domain/data/data.dart';
import 'package:godeye_parser/domain/models/models.dart';
import 'package:godeye_parser/features/full_text_search/full_text_search.dart';
import 'package:godeye_parser/ui/theme/theme.dart';
import 'package:godeye_parser/ui/widgets/widgets.dart';

class InfoDataWdget extends StatelessWidget {
  const InfoDataWdget({
    super.key,
    required this.isFullScreen,
  });

  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: isFullScreen ? 700 : size.width,
        height: 600,
        decoration: BoxDecoration(
          color: ColorsList.blockBackgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(isFullScreen ? 15 : 5),
              child: Text(
                'Найденные телефоны',
                style: theme.textTheme.headlineMedium!
                    .copyWith(fontSize: isFullScreen ? 28 : 20),
              ),
            ),
            Expanded(
              child: BlocBuilder<TextSearchBloc, TextSearchState>(
                builder: (context, state) {
                  if (state is TextInitial) {
                    return const SearchEmpty();
                  } else if (state is TextLoaded) {
                    return SearchSuccessRegion(
                      allPhones: state.allPhones,
                      regionPhones: state.correctedPhones,
                      isFullScreen: isFullScreen,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextSearchButtonRow extends StatelessWidget {
  const TextSearchButtonRow({
    super.key,
    required this.textController,
    required this.isFullScreen,
  });

  final bool isFullScreen;
  final TextEditingController textController;

  void _search(BuildContext context) {
    final textItem = isFullScreen
        ? context.read<FullSearchingData>().textItem
        : context.read<TextSearchingDataItem>();
    if (textItem.regionToSearch.isNotEmpty) {
      context.read<TextSearchBloc>().add(
            SearchByRegion(
              text: textItem.controllerText,
              region: DrowDownRegionsData.regionMap[textItem.regionToSearch]!,
            ),
          );
    }
  }

  Future<void> _pasteAndSaveData(BuildContext context) async {
    final cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null && context.mounted) {
      textController.text = cdata.text ?? textController.text;
      if (isFullScreen) {
        context.read<FullSearchingData>().textItem.controllerText =
            textController.text;
      } else {
        context.read<TextSearchingDataItem>().controllerText =
            textController.text;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _TextSearchFilledButton(
          onPressed: () => _pasteAndSaveData(context),
          text: 'Вставить',
          isFullScreen: isFullScreen,
        ),
        _TextSearchFilledButton(
          onPressed: () => _search(context),
          text: 'Найти',
          isFullScreen: isFullScreen,
        ),
      ],
    );
  }
}

class TextSearchTextField extends StatelessWidget {
  const TextSearchTextField({
    super.key,
    required this.controller,
    required this.isFullScreen,
  });

  final bool isFullScreen;
  final TextEditingController controller;

  OutlineInputBorder _border(double width) => OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorsList.primary,
          width: width,
        ),
        borderRadius: BorderRadius.circular(15),
      );

  void _saveValue(BuildContext context, String value) {
    controller.text = value;
    if (isFullScreen) {
      context.read<FullSearchingData>().textItem.controllerText = value;
    } else {
      context.read<TextSearchingDataItem>().controllerText = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: isFullScreen ? size.width / 2.5 : size.width,
      child: TextField(
        controller: controller,
        minLines: isFullScreen ? 18 : size.height ~/ 75,
        maxLines: isFullScreen ? 18 : size.height ~/ 75,
        onChanged: (value) => _saveValue(context, value),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Введите текст',
          hintStyle: TextStyle(
            color: ColorsList.hintRegionTextColor,
            fontSize: 18,
          ),
          enabledBorder: _border(4),
          focusedBorder: _border(2),
        ),
      ),
    );
  }
}

class _TextSearchFilledButton extends StatelessWidget {
  const _TextSearchFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isFullScreen,
  });

  final bool isFullScreen;
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilledButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(
          EdgeInsets.only(left: 30, right: 30, bottom: 12),
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge!
            .copyWith(fontSize: isFullScreen ? 25 : 12),
      ),
    );
  }
}
