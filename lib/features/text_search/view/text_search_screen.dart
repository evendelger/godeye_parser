import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/features/text_search/bloc/text_bloc.dart';
import 'package:phone_corrector/ui/widgets/widgets.dart';

class TextSearchScreen extends StatefulWidget {
  const TextSearchScreen({super.key});

  @override
  State<TextSearchScreen> createState() => _TextSearchScreenState();
}

class _TextSearchScreenState extends State<TextSearchScreen> {
  late final TextEditingController textController;
  late final TextEditingController regionController;

  @override
  void initState() {
    textController = TextEditingController();
    regionController = TextEditingController();
    super.initState();
    final textItem = context.read<SearchingDataList>().textItem;
    textController.text = textItem.controllerText;
  }

  @override
  void dispose() {
    textController.dispose();
    regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialValue =
        context.read<SearchingDataList>().textItem.regionToSearch;

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //const SizedBox(height: 70),
                const Spacer(),
                DropDownListWidget(
                  controller: regionController,
                  typeOfProvider: TypeOfProvider.textSearch,
                  width: 700,
                  height: null,
                  contentPadding: const EdgeInsets.only(
                    bottom: 5,
                    left: 15,
                    right: 15,
                  ),
                  fontSize: 30,
                  overflow: TextOverflow.visible,
                  initialValue: initialValue.isEmpty ? null : initialValue,
                ),
                const SizedBox(height: 30),
                _TextField(controller: textController),
                const SizedBox(height: 30),
                _ButtonsRow(textController: textController),
                const Spacer(),
              ],
            ),
          ),
          const Flexible(
            child: _InfoDataWdget(),
          ),
        ],
      ),
    );
  }
}

class _InfoDataWdget extends StatelessWidget {
  const _InfoDataWdget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: 650,
        height: 650,
        decoration: BoxDecoration(
          color: theme.hintColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Найденные телефоны',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Spacer(),
            BlocBuilder<TextBloc, TextState>(
              builder: (context, state) {
                if (state is TextInitial) {
                  return const Text('Начните поиск.');
                } else if (state is TextLoading) {
                  return const CircularProgressIndicator();
                } else if (state is TextLoaded) {
                  return _LoadedDataWidget(state: state);
                } else if (state is TextLoadingFailure) {
                  return const Text('Произошла ошибка, повторите позже');
                }
                return const SizedBox.shrink();
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _LoadedDataWidget extends StatelessWidget {
  const _LoadedDataWidget({
    super.key,
    required this.state,
  });

  final TextLoaded state;

  @override
  Widget build(BuildContext context) {
    return RegionInfoWidget(
      allPhones: state.allPhones,
      regionPhones: state.correctedPhones,
    );
  }
}

class _ButtonsRow extends StatelessWidget {
  const _ButtonsRow({
    super.key,
    required this.textController,
  });

  final TextEditingController textController;

  void _search(BuildContext context) {
    final textItem = context.read<SearchingDataList>().textItem;
    context.read<TextBloc>().add(
          SearchByRegion(
            text: textItem.controllerText,
            region: textItem.regionToSearch,
          ),
        );
  }

  Future<void> _pasteAndSaveData(BuildContext context) async {
    final cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null && context.mounted) {
      textController.text = cdata.text ?? textController.text;
      context.read<SearchingDataList>().textItem.controllerText =
          textController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _FilledButton(
          onPressed: () => _pasteAndSaveData(context),
          text: 'Вставить',
        ),
        _FilledButton(
          onPressed: () => _search(context),
          text: 'Найти',
        ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  OutlineInputBorder _border(double width, ThemeData theme) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.primaryColor,
          width: width,
        ),
        borderRadius: BorderRadius.circular(15),
      );

  void _saveValue(BuildContext context, String value) {
    controller.text = value;
    context.read<SearchingDataList>().textItem.controllerText = value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 750,
      child: TextField(
        controller: controller,
        minLines: 20,
        maxLines: 20,
        onChanged: (value) => _saveValue(context, value),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Введите текст',
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.4),
            fontSize: 18,
          ),
          enabledBorder: _border(4, theme),
          focusedBorder: _border(2, theme),
        ),
      ),
    );
  }
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(
          EdgeInsets.only(left: 30, right: 30, bottom: 12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
