import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_corrector/domain/data/data.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/features/full_file_search/widgets/widgets.dart';
import 'package:phone_corrector/features/mini_file_search/bloc/mini_search_bloc.dart';
import 'package:phone_corrector/repositories/repositories.dart';
import 'package:phone_corrector/service_locator.dart';
import 'package:phone_corrector/ui/widgets/widgets.dart';
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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    cityController = TextEditingController();
    experienceController = TextEditingController();
    regionController = TextEditingController();
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
        Provider<MiniSearchingData>(
          create: (_) => MiniSearchingData.init(),
          lazy: false,
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                fillOverscroll: true,
                child: Column(
                  children: [
                    _NameRow(
                      size: size,
                      controllers: [
                        nameController,
                        cityController,
                        experienceController,
                      ],
                    ),
                    const SizedBox(height: 5),
                    _FindDataRow(
                      searchType: SearchType.region,
                      isRegionSearch: true,
                      controller: regionController,
                    ),
                    const SizedBox(height: 5),
                    _FindDataRow(
                      searchType: SearchType.city,
                      isRegionSearch: false,
                      controller: cityController,
                      hintText: 'Введите город',
                      parseType: ParseType.city,
                    ),
                    const SizedBox(height: 5),
                    _FindDataRow(
                      searchType: SearchType.experience,
                      isRegionSearch: false,
                      controller: experienceController,
                      hintText: 'Введите стаж',
                      parseType: ParseType.experience,
                    ),
                    const SizedBox(height: 5),
                    const _ResultData(),
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

class _NameRow extends StatelessWidget {
  const _NameRow({
    super.key,
    required this.size,
    required this.controllers,
  });

  final List<TextEditingController> controllers;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            searchingDataType: SearchingDataType.mini,
            width: null,
            controller: controllers[0],
            hintText: 'Введите ФИО',
            parseType: ParseType.name,
            maxLines: null,
            fontSize: min(size.width / 22, 23),
            height: size.height / 10 > 60 ? 60 : size.height / 10,
          ),
        ),
        _ResetButton(controllers: controllers),
      ],
    );
  }
}

class _FindDataRow extends StatelessWidget {
  const _FindDataRow({
    super.key,
    required this.searchType,
    required this.isRegionSearch,
    required this.controller,
    this.hintText,
    this.parseType,
  });

  final SearchType searchType;
  final bool isRegionSearch;
  final TextEditingController controller;
  final String? hintText;
  final ParseType? parseType;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        Expanded(
          child: isRegionSearch
              ? DropDownListWidget(
                  controller: controller,
                  typeOfProvider: ProviderType.miniFilesSearch,
                  width: null,
                  contentPadding: const EdgeInsets.only(left: 40, bottom: 2),
                  fontSelectedSize: 18,
                  overflow: TextOverflow.ellipsis,
                  initialValue: null,
                  screenType: ScreenType.mini,
                  fontItembuilderSize: 16,
                  height: size.height / 18 < 30 ? 30 : size.height / 18,
                )
              : CustomTextField(
                  searchingDataType: SearchingDataType.mini,
                  width: null,
                  controller: controller,
                  hintText: hintText!,
                  parseType: parseType!,
                  fontSize: 18,
                  maxLines: 1,
                  height: size.height / 12 > 50 ? 50 : size.height / 12,
                ),
        ),
        const SizedBox(width: 5),
        _CustomSearchButton(searchType: searchType),
        const SizedBox(width: 5),
        _CustomShowButton(searchType: searchType),
      ],
    );
  }
}

class _CustomSearchButton extends StatelessWidget {
  const _CustomSearchButton({
    super.key,
    required this.searchType,
  });

  final SearchType searchType;

  void _search(BuildContext context) {
    final itemModel = context.read<MiniSearchingData>().controllers;
    final bloc = context.read<MiniSearchBloc>();

    switch (searchType) {
      case SearchType.region:
        {
          if (itemModel.regionToSearch.isEmpty ||
              bloc.state.model.stateModel.statuses.regionStatus ==
                  SearchStatus.inProgress) return;
        }
      case SearchType.city:
        {
          if (itemModel.cityControllerText.isEmpty ||
              bloc.state.model.stateModel.statuses.cityStatus ==
                  SearchStatus.inProgress) return;
        }
      case SearchType.experience:
        {
          if (itemModel.experienceControllerText.isEmpty ||
              bloc.state.model.stateModel.statuses.experienceStatus ==
                  SearchStatus.inProgress) return;
        }
    }

    switch (searchType) {
      case SearchType.region:
        bloc.add(SearchByRegion(
          name: itemModel.nameControllerText,
          region: DrowDownRegionsData.regionMap[itemModel.regionToSearch]!,
        ));
      case SearchType.city:
        bloc.add(SearchByCity(
          name: itemModel.nameControllerText,
          city: itemModel.cityControllerText,
        ));
      case SearchType.experience:
        bloc.add(SearchByExperience(
          name: itemModel.nameControllerText,
          experience: itemModel.experienceControllerText,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton.filled(
        padding: EdgeInsets.zero,
        iconSize: 20,
        onPressed: () => _search(context),
        icon: const Icon(Icons.search),
      ),
    );
  }
}

class _CustomShowButton extends StatelessWidget {
  const _CustomShowButton({
    super.key,
    required this.searchType,
  });

  final SearchType searchType;

  void _showData(BuildContext context) {
    final bloc = context.read<MiniSearchBloc>();
    switch (searchType) {
      case SearchType.region:
        bloc.add(const ShowRegionData());
      case SearchType.city:
        bloc.add(const ShowCityData());
      case SearchType.experience:
        bloc.add(const ShowExperienceData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton.filled(
        padding: EdgeInsets.zero,
        iconSize: 20,
        onPressed: () => _showData(context),
        icon: const Icon(Icons.description),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({
    super.key,
    required this.controllers,
  });

  final List<TextEditingController> controllers;

  void _clearData(BuildContext context) {
    context.read<MiniSearchBloc>().add(const ClearData());
    for (var c in controllers) {
      c.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton.filled(
        padding: EdgeInsets.zero,
        iconSize: 20,
        onPressed: () => _clearData(context),
        icon: const Icon(Icons.restart_alt),
      ),
    );
  }
}

class _ResultData extends StatelessWidget {
  const _ResultData({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        width: size.width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: theme.hintColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: BlocBuilder<MiniSearchBloc, MiniSearchState>(
            builder: (context, state) {
              if (state is MiniSearchInitial) {
                return const SearchInitial();
              } else if (state is MiniSearchInProgress) {
                return const SearchInProgress();
              } else if (state is MiniSearchFailed) {
                return const SearchFailed();
              } else if (state is MiniSearchRegionInfo) {
                return SearchSuccessRegion(
                  regionPhones: state.regionPhones,
                  allPhones: state.allPhones,
                );
              } else if (state is MiniSearchCityInfo) {
                return SearchSuccessCity(
                  cityRegionPhones: state.cityRegionPhones,
                  cityPhones: state.cityPhones,
                  allPhones: state.allPhones,
                );
              } else if (state is MiniSearchExperienceInfo) {
                return SearchSuccessExperience(
                  experienceToSearch: state.experienceToSearch,
                  experienceRegionPhones: state.experienceRegionPhones,
                  experiencePhones: state.experiencePhones,
                  allPhones: state.allPhones,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
