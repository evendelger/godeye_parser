part of 'mini_search_bloc.dart';

class MiniSearchState extends Equatable {
  const MiniSearchState({required this.model});

  final PersonFileModel model;

  @override
  List<Object> get props => [model];
}

final class MiniSearchInitial extends MiniSearchState {
  const MiniSearchInitial({required super.model});
}

final class MiniSearchInProgress extends MiniSearchState {
  const MiniSearchInProgress({required super.model});
}

final class MiniSearchFailed extends MiniSearchState {
  const MiniSearchFailed({required super.model});
}

final class MiniSearchRegionInfo extends MiniSearchState {
  const MiniSearchRegionInfo({
    required this.regionPhones,
    required this.allPhones,
    required super.model,
  });

  final List<String> regionPhones;
  final List<String> allPhones;

  @override
  List<Object> get props => [regionPhones, allPhones];
}

final class MiniSearchCityInfo extends MiniSearchState {
  const MiniSearchCityInfo({
    required this.cityRegionPhones,
    required this.cityPhones,
    required this.allPhones,
    required super.model,
  });

  final List<String> cityRegionPhones;
  final List<String> cityPhones;
  final List<String> allPhones;

  @override
  List<Object> get props => [cityRegionPhones, cityPhones, allPhones];
}

final class MiniSearchExperienceInfo extends MiniSearchState {
  const MiniSearchExperienceInfo({
    required super.model,
    required this.experienceToSearch,
    required this.experienceRegionPhones,
    required this.experiencePhones,
    required this.regionPhonesWithoutDate,
    required this.phonesWithoutDate,
    required this.allPhones,
  });

  final String experienceToSearch;
  final MapList experienceRegionPhones;
  final MapList experiencePhones;
  final List<String> regionPhonesWithoutDate;

  final List<String> phonesWithoutDate;
  final List<String> allPhones;

  @override
  List<Object> get props => [
        experienceToSearch,
        experienceRegionPhones,
        experiencePhones,
        regionPhonesWithoutDate,
        phonesWithoutDate,
        allPhones,
      ];
}
