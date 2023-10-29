import 'package:flutter/material.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:godeye_parser/domain/domain.dart';
import 'package:godeye_parser/features/full_file_search/full_file_search.dart';
import 'package:godeye_parser/features/mini_file_search/mini_file_search.dart';
import 'package:godeye_parser/service_locator.dart';
import 'package:godeye_parser/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MiniFileSeacrhScreen extends StatefulWidget {
  const MiniFileSeacrhScreen({super.key});

  @override
  State<MiniFileSeacrhScreen> createState() => _MiniFileSeacrhScreenState();
}

class _MiniFileSeacrhScreenState extends State<MiniFileSeacrhScreen> {
  late final TextEditingController nameController;
  late final TextEditingController cityController;
  late final TextEditingController experienceController;
  late final TextEditingController regionController;
  String initialValue = '';

  @override
  void initState() {
    nameController = TextEditingController();
    cityController = TextEditingController();
    experienceController = TextEditingController();
    regionController = TextEditingController();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final fileItem = await DatabaseHelper.instance.selectFileItem(0);
      nameController.text = fileItem.nameControllerText;
      cityController.text = fileItem.cityControllerText;
      experienceController.text = fileItem.experienceControllerText;
      initialValue = fileItem.regionToSearch;
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    experienceController.dispose();
    regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        Provider<MiniSearchBloc>(
          create: (_) => MiniSearchBloc(
            phonesRepository: getIt<AbstractPhonesDataRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                fillOverscroll: true,
                child: Column(
                  children: [
                    NameRow(
                      size: size,
                      controllers: [
                        nameController,
                        cityController,
                        experienceController,
                      ],
                    ),
                    FindDataRow(
                      searchType: SearchType.region,
                      isRegionSearch: true,
                      controller: regionController,
                      initialValue: initialValue,
                    ),
                    const SizedBox(height: 5),
                    FindDataRow(
                      searchType: SearchType.city,
                      isRegionSearch: false,
                      controller: cityController,
                      hintText: 'Введите город',
                      parseType: ParseType.city,
                    ),
                    const SizedBox(height: 5),
                    FindDataRow(
                      searchType: SearchType.experience,
                      isRegionSearch: false,
                      controller: experienceController,
                      hintText: 'Введите стаж',
                      parseType: ParseType.experience,
                    ),
                    const SizedBox(height: 5),
                    const ResultData(),
                    const SizedBox(height: 5),
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
