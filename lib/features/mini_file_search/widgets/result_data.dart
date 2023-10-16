import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:godeye_parser/features/mini_file_search/bloc/mini_search_bloc.dart';
import 'package:godeye_parser/ui/theme/theme.dart';
import 'package:godeye_parser/ui/widgets/search_data_widgets.dart';

class ResultData extends StatelessWidget {
  const ResultData({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        width: size.width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: ColorsList.blockBackgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: BlocBuilder<MiniSearchBloc, MiniSearchState>(
            builder: (context, state) {
              if (state is MiniSearchInitial) {
                return const SearchEmpty();
              } else if (state is MiniSearchInProgress) {
                return const SearchInProgress();
              } else if (state is MiniSearchFailed) {
                return const SearchFailed();
              } else if (state is MiniSearchRegionInfo) {
                return SearchSuccessRegion(
                  regionPhones: state.regionPhones,
                  allPhones: state.allPhones,
                  isFullScreen: false,
                );
              } else if (state is MiniSearchCityInfo) {
                return SearchSuccessCity(
                  cityRegionPhones: state.cityRegionPhones,
                  cityPhones: state.cityPhones,
                  allPhones: state.allPhones,
                  isFullScreen: false,
                );
              } else if (state is MiniSearchExperienceInfo) {
                return SearchSuccessExperience(
                  experienceToSearch: state.experienceToSearch,
                  experienceRegionPhones: state.experienceRegionPhones,
                  experiencePhones: state.experiencePhones,
                  allPhones: state.allPhones,
                  phonesWithoutDate: state.phonesWithoutDate,
                  isFullScreen: false,
                  regionPhonesWithoutDate: state.regionPhonesWithoutDate,
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
