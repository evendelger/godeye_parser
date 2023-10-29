import 'package:flutter/material.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:godeye_parser/domain/domain.dart';
import 'package:godeye_parser/features/full_text_search/full_text_search.dart';
import 'package:godeye_parser/service_locator.dart';
import 'package:godeye_parser/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MiniTextSearchScreen extends StatefulWidget {
  const MiniTextSearchScreen({super.key});

  @override
  State<MiniTextSearchScreen> createState() => _MiniTextSearchScreenState();
}

class _MiniTextSearchScreenState extends State<MiniTextSearchScreen> {
  late final TextEditingController textController;
  late final TextEditingController regionController;
  String initialValue = '';
  @override
  void initState() {
    textController = TextEditingController();
    regionController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var textItem = await DatabaseHelper.instance.selectTextItem();
      textController.text = textItem.controllerText;
      initialValue = textItem.regionToSearch;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TextSearchBloc>(
          create: (_) => TextSearchBloc(
            phonesRepository: getIt<AbstractPhonesDataRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: true,
                child: Column(
                  children: [
                    DropDownListWidget(
                      controller: regionController,
                      width: null,
                      height: 30,
                      contentPadding: const EdgeInsets.only(
                        bottom: 5,
                        left: 15,
                        right: 15,
                      ),
                      fontSelectedSize: 20,
                      overflow: TextOverflow.ellipsis,
                      initialValue: initialValue.isEmpty ? null : initialValue,
                      dataType: DataType.text,
                      fontItembuilderSize: 16,
                    ),
                    const SizedBox(height: 5),
                    TextSearchTextField(
                      controller: textController,
                      isFullScreen: false,
                    ),
                    const SizedBox(height: 5),
                    TextSearchButtonRow(
                      textController: textController,
                      isFullScreen: false,
                    ),
                    const SizedBox(height: 5),
                    const InfoDataWdget(isFullScreen: false),
                    const MiniSearchActionButtonsRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
