import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:godeye_parser/domain/domain.dart';
import 'package:godeye_parser/features/full_file_search/widgets/widgets.dart';
import 'package:godeye_parser/features/mini_file_search/mini_file_search.dart';

class CustomSearchButton extends StatelessWidget {
  const CustomSearchButton({
    super.key,
    required this.searchType,
  });

  final SearchType searchType;

  void _search(BuildContext context) async {
    final bloc = context.read<MiniSearchBloc>();
    final itemModel = await DatabaseHelper.instance.selectFileItem(0);

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
