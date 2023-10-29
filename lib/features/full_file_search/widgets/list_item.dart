import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:godeye_parser/domain/domain.dart';
import 'package:godeye_parser/features/full_file_search/full_file_search.dart';
import 'package:godeye_parser/ui/theme/theme.dart';
import 'package:godeye_parser/ui/widgets/widgets.dart';

enum SearchType {
  region,
  city,
  experience,
}

class ListItem extends StatefulWidget {
  const ListItem({
    super.key,
    required this.index,
    required this.fileSearchData,
  });

  final int index;
  final FileSearchData fileSearchData;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late final TextEditingController nameController;
  late final TextEditingController cityController;
  late final TextEditingController experienceController;
  late final String regionToSearch;

  @override
  void initState() {
    nameController = TextEditingController()
      ..text = widget.fileSearchData.nameControllerText;
    cityController = TextEditingController()
      ..text = widget.fileSearchData.cityControllerText;
    experienceController = TextEditingController()
      ..text = widget.fileSearchData.experienceControllerText;
    regionToSearch = widget.fileSearchData.regionToSearch;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RowIndex(index: widget.index),
          Expanded(
            child: CustomTextField(
              searchingDataType: SearchingDataType.full,
              index: widget.index,
              width: null,
              controller: nameController,
              hintText: 'Введите ФИО',
              parseType: ParseType.name,
              height: null,
              fontSize: 18,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 10),
          _RowRegionSearch(
            index: widget.index,
            initialValue: regionToSearch,
          ),
          _RowCitySearch(
            cityController: cityController,
            index: widget.index,
          ),
          _RowExperienceSearch(
            experienceController: experienceController,
            index: widget.index,
          ),
          _RowIconsStatus(index: widget.index),
          const SizedBox(width: 10),
          _ClearButton(
            controllers: [nameController, cityController, experienceController],
            index: widget.index,
          ),
        ],
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({
    super.key,
    required this.controllers,
    required this.index,
  });

  final List<TextEditingController> controllers;
  final int index;

  void _clearItem(BuildContext context, int index) {
    context.read<FullSearchBloc>().add(ClearItem(index: index));
    for (var c in controllers) {
      c.clear();
    }
    DatabaseHelper.instance.clearItem(index);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _clearItem(context, index),
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.delete,
        size: 35,
        color: ColorsList.deleteColor,
      ),
    );
  }
}

class _RowIconsStatus extends StatelessWidget {
  const _RowIconsStatus({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColorsList.blockBackgroundColor,
        border: Border.all(
          color: ColorsList.blockBackgroundColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          _SingleIconStatus(
            icon: Icons.person,
            index: index,
            searchType: SearchType.region,
          ),
          _SingleIconStatus(
            icon: Icons.location_city,
            index: index,
            searchType: SearchType.city,
          ),
          _SingleIconStatus(
            icon: Icons.work,
            index: index,
            searchType: SearchType.experience,
          ),
        ],
      ),
    );
  }
}

class _SingleIconStatus extends StatelessWidget {
  const _SingleIconStatus({
    super.key,
    required this.icon,
    required this.index,
    required this.searchType,
  });

  final IconData icon;
  final int index;
  final SearchType searchType;

  Color _getColor(PersonStateModel stateModel) {
    final searchStatus = switch (searchType) {
      SearchType.region => stateModel.statuses.regionStatus,
      SearchType.city => stateModel.statuses.cityStatus,
      SearchType.experience => stateModel.statuses.experienceStatus,
    };

    switch (searchStatus) {
      case SearchStatus.waiting:
        return ColorsList.waitingColor;
      case SearchStatus.inProgress:
        return ColorsList.progressColor;
      case SearchStatus.success:
        return ColorsList.successColor;
      case SearchStatus.error:
        return ColorsList.errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FullSearchBloc, FullSearchState>(
      buildWhen: (previous, current) {
        if (current is FileSearchInProgress &&
            current.index == index &&
            current.searchType == searchType) return true;
        if (current is FileSearchFailed &&
            current.index == index &&
            current.searchType == searchType) return true;

        switch (searchType) {
          case SearchType.region:
            if (current is FileSearchRegionInfo && current.index == index) {
              return true;
            }
          case SearchType.city:
            if (current is FileSearchCityInfo && current.index == index) {
              return true;
            }
          case SearchType.experience:
            if (current is FileSearchExperienceInfo && current.index == index) {
              return true;
            }
        }
        return false;
      },
      builder: (context, state) {
        final stateModel = state.models[index].stateModel;
        return Icon(
          icon,
          color: _getColor(stateModel),
          size: 35,
        );
      },
    );
  }
}

class _RowExperienceSearch extends StatelessWidget {
  const _RowExperienceSearch({
    super.key,
    required this.experienceController,
    required this.index,
  });

  final TextEditingController experienceController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTextField(
          searchingDataType: SearchingDataType.full,
          index: index,
          width: 110,
          controller: experienceController,
          hintText: 'Стаж',
          parseType: ParseType.experience,
          height: null,
          fontSize: 19,
          maxLines: 1,
        ),
        _SearchButton(searchType: SearchType.experience, index: index),
        _ShowButton(searchType: SearchType.experience, index: index),
      ],
    );
  }
}

class _RowCitySearch extends StatelessWidget {
  const _RowCitySearch({
    super.key,
    required this.cityController,
    required this.index,
  });

  final TextEditingController cityController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTextField(
          searchingDataType: SearchingDataType.full,
          index: index,
          width: 175,
          controller: cityController,
          hintText: 'Введите город',
          parseType: ParseType.city,
          height: null,
          fontSize: 19,
          maxLines: 1,
        ),
        _SearchButton(searchType: SearchType.city, index: index),
        _ShowButton(searchType: SearchType.city, index: index),
      ],
    );
  }
}

class _RowIndex extends StatelessWidget {
  const _RowIndex({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsList.primaryWithMediumOpacity,
        border: Border.all(width: 1, color: ColorsList.blackWithMediumOpacity),
      ),
      child: Text(
        '${index + 1}',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class _RowRegionSearch extends StatelessWidget {
  const _RowRegionSearch({
    super.key,
    required this.index,
    required this.initialValue,
  });

  final int index;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropDownListWidget(
          index: index,
          controller: TextEditingController(),
          width: 312,
          height: 30,
          contentPadding: const EdgeInsets.only(bottom: 3, left: 40),
          fontSelectedSize: 19,
          overflow: TextOverflow.ellipsis,
          initialValue: initialValue.isEmpty ? null : initialValue,
          dataType: DataType.file,
          fontItembuilderSize: 20,
        ),
        _SearchButton(searchType: SearchType.region, index: index),
        _ShowButton(searchType: SearchType.region, index: index),
      ],
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton(
      {super.key, required this.searchType, required this.index});

  final SearchType searchType;
  final int index;

  void _search(BuildContext context) async {
    final bloc = context.read<FullSearchBloc>();
    _showDialog(context, bloc);
    final itemModel = await DatabaseHelper.instance.selectFileItem(index);

    switch (searchType) {
      case SearchType.region:
        {
          if (itemModel.regionToSearch.isEmpty ||
              bloc.state.models[index].stateModel.statuses.regionStatus ==
                  SearchStatus.inProgress) return;
        }
      case SearchType.city:
        {
          if (itemModel.cityControllerText.isEmpty ||
              bloc.state.models[index].stateModel.statuses.cityStatus ==
                  SearchStatus.inProgress) return;
        }
      case SearchType.experience:
        {
          if (itemModel.experienceControllerText.isEmpty ||
              bloc.state.models[index].stateModel.statuses.experienceStatus ==
                  SearchStatus.inProgress) return;
        }
    }

    switch (searchType) {
      case SearchType.region:
        bloc.add(SearchByRegion(
          index: index,
          name: itemModel.nameControllerText,
          region: DrowDownRegionsData.regionMap[itemModel.regionToSearch]!,
        ));
      case SearchType.city:
        bloc.add(SearchByCity(
          index: index,
          name: itemModel.nameControllerText,
          city: itemModel.cityControllerText,
        ));
      case SearchType.experience:
        bloc.add(SearchByExperience(
          index: index,
          name: itemModel.nameControllerText,
          experience: itemModel.experienceControllerText,
        ));
    }
  }

  void _showDialog(BuildContext context, FullSearchBloc bloc) {
    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider<FullSearchBloc>.value(
          value: bloc,
          child: _AlertDialog(searchType: searchType, index: index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _search(context),
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.search,
        color: Colors.black,
      ),
    );
  }
}

class _ShowButton extends StatelessWidget {
  const _ShowButton({
    super.key,
    required this.searchType,
    required this.index,
  });

  final SearchType searchType;
  final int index;

  void _showDialog(BuildContext context) {
    final bloc = context.read<FullSearchBloc>();

    switch (searchType) {
      case SearchType.region:
        bloc.add(ShowRegionData(index: index));
      case SearchType.city:
        bloc.add(ShowCityData(index: index));
      case SearchType.experience:
        bloc.add(ShowExperienceData(index: index));
    }

    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider<FullSearchBloc>.value(
          value: bloc,
          child: _AlertDialog(searchType: searchType, index: index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showDialog(context),
      icon: const Icon(
        Icons.description,
        color: Colors.black,
      ),
    );
  }
}

class _AlertDialog extends StatelessWidget {
  const _AlertDialog({
    super.key,
    required this.searchType,
    required this.index,
  });

  final int index;
  final SearchType searchType;

  List<Widget> _title(ThemeData theme, FullSearchState state) {
    String getFullRegion(String shortRegion) {
      const map = DrowDownRegionsData.regionMap;
      return map.keys.firstWhere(
        (key) => map[key] == shortRegion,
        orElse: () => 'ОШИБКА',
      );
    }

    return [
      Text(
        'Найденные телефоны',
        style: theme.textTheme.bodyLarge,
      ),
      state.models[index].name.isEmpty
          ? const SizedBox.shrink()
          : Text(
              state.models[index].name,
              style: theme.textTheme.titleLarge,
            ),
      state.models[index].stateModel.regionToSearch == null
          ? const SizedBox.shrink()
          : Text(
              getFullRegion(state.models[index].stateModel.regionToSearch!),
              style: theme.textTheme.titleMedium,
            ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<FullSearchBloc, FullSearchState>(
      builder: (context, state) {
        child() {
          if (state is FileSearchEmpty) {
            return const SearchEmpty();
          } else if (state is FileSearchInProgress) {
            return const SearchInProgress();
          } else if (state is FileSearchFailed) {
            return const SearchFailed();
          } else if (state is FileSearchRegionInfo) {
            return SearchSuccessRegion(
              regionPhones: state.regionPhones,
              allPhones: state.allPhones,
              isFullScreen: true,
            );
          } else if (state is FileSearchCityInfo) {
            return SearchSuccessCity(
              cityRegionPhones: state.cityRegionPhones,
              cityPhones: state.cityPhones,
              allPhones: state.allPhones,
              isFullScreen: true,
            );
          } else if (state is FileSearchExperienceInfo) {
            return SearchSuccessExperience(
              experienceToSearch: state.experienceToSearch,
              experienceRegionPhones: state.experienceRegionPhones,
              experiencePhones: state.experiencePhones,
              allPhones: state.allPhones,
              phonesWithoutDate: state.phonesWithoutDate,
              isFullScreen: true,
              regionPhonesWithoutDate: state.regionPhonesWithoutDate,
            );
          }
          return const SizedBox.shrink();
        }

        return AlertDialog(
          title: Column(
            children: _title(theme, state),
          ),
          content: SizedBox(
            height: 600,
            width: 600,
            child: child.call(),
          ),
        );
      },
    );
  }
}
