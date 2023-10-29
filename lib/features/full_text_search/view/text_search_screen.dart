import 'package:flutter/material.dart';
import 'package:godeye_parser/data/database/database_helper.dart';
import 'package:godeye_parser/ui/widgets/widgets.dart';

class FullTextSearchScreen extends StatefulWidget {
  const FullTextSearchScreen({super.key});

  @override
  State<FullTextSearchScreen> createState() => _FullTextSearchScreenState();
}

class _FullTextSearchScreenState extends State<FullTextSearchScreen> {
  late final TextEditingController textController;
  late final TextEditingController regionController;
  String initialValue = '';

  @override
  void initState() {
    textController = TextEditingController();
    regionController = TextEditingController();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final textItem = await DatabaseHelper.instance.selectTextItem();
      textController.text = textItem.controllerText;
      initialValue = textItem.regionToSearch;
      setState(() {});
    });
  }

  @override
  void dispose() {
    textController.dispose();
    regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    dataType: DataType.text,
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
