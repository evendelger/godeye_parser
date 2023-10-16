import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:godeye_parser/features/full_file_search/widgets/widgets.dart';
import 'package:godeye_parser/features/mini_file_search/bloc/mini_search_bloc.dart';

class CustomShowButton extends StatelessWidget {
  const CustomShowButton({
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
