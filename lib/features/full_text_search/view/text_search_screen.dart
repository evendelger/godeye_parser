import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:godeye_parser/domain/models/models.dart';
import 'package:godeye_parser/ui/widgets/widgets.dart';

class FullTextSearchScreen extends StatefulWidget {
  const FullTextSearchScreen({super.key});

  @override
  State<FullTextSearchScreen> createState() => _FullTextSearchScreenState();
}

class _FullTextSearchScreenState extends State<FullTextSearchScreen> {
  late final TextEditingController textController;
  late final TextEditingController regionController;

  @override
  void initState() {
    textController = TextEditingController();
    regionController = TextEditingController();
    super.initState();
    final textItem = context.read<FullSearchingData>().textItem;
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
        context.read<FullSearchingData>().textItem.regionToSearch;
    final size = MediaQuery.of(context).size;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  DropDownListWidget(
                    controller: regionController,
                    typeOfProvider: ProviderType.fullTextSearch,
                    width: size.width / 2.5,
                    height: null,
                    contentPadding: const EdgeInsets.only(
                      bottom: 5,
                      left: 15,
                      right: 15,
                    ),
                    fontSelectedSize: 30,
                    overflow: TextOverflow.visible,
                    initialValue: initialValue.isEmpty ? null : initialValue,
                    screenType: ScreenType.full,
                    fontItembuilderSize: 20,
                  ),
                  const SizedBox(height: 30),
                  TextSearchTextField(
                    controller: textController,
                    isFullScreen: true,
                  ),
                  const SizedBox(height: 30),
                  TextSearchButtonRow(
                    textController: textController,
                    isFullScreen: true,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Flexible(
              child: InfoDataWdget(isFullScreen: true),
            ),
          ],
        ),
      ),
    );
  }
}
