part of 'full_search_bloc.dart';

class FullSearchState extends Equatable {
  const FullSearchState({required this.models});

  final List<PersonFileModel> models;

  factory FullSearchState.init() {
    return FileSearchEmpty(
      models: List<PersonFileModel>.generate(
        5,
        (_) => PersonFileModel.empty(),
        growable: true,
      ),
    );
  }

  FullSearchState copyWith({
    List<PersonFileModel>? models,
  }) {
    return FullSearchState(
      models: models ?? this.models,
    );
  }

  @override
  List<Object?> get props => [models];
}

final class FileSearchEmpty extends FullSearchState {
  const FileSearchEmpty({required super.models});
}

final class FileSearchInProgress extends FullSearchState {
  const FileSearchInProgress({
    required super.models,
    required this.searchType,
    required this.index,
  });

  final SearchType searchType;
  final int index;
}

final class FileSearchFailed extends FullSearchState {
  const FileSearchFailed({
    required super.models,
    required this.searchType,
    required this.index,
  });

  final SearchType searchType;
  final int index;
}

final class FileSearchRegionInfo extends FullSearchState {
  const FileSearchRegionInfo({
    required this.index,
    required this.regionPhones,
    required this.allPhones,
    required super.models,
  });

  final int index;
  final List<String> regionPhones;
  final List<String> allPhones;

  @override
  List<Object> get props => [regionPhones, allPhones];
}

final class FileSearchCityInfo extends FullSearchState {
  const FileSearchCityInfo({
    required this.index,
    required this.cityRegionPhones,
    required this.cityPhones,
    required this.allPhones,
    required super.models,
  });

  final int index;
  final List<String> cityRegionPhones;
  final List<String> cityPhones;
  final List<String> allPhones;

  @override
  List<Object> get props => [cityRegionPhones, cityPhones, allPhones];
}

final class FileSearchExperienceInfo extends FullSearchState {
  const FileSearchExperienceInfo({
    required this.index,
    required this.experienceToSearch,
    required this.experienceRegionPhones,
    required this.experiencePhones,
    required this.regionPhonesWithoutDate,
    required this.phonesWithoutDate,
    required this.allPhones,
    required super.models,
  });

  final int index;
  final String experienceToSearch;
  final MapList experienceRegionPhones;
  final MapList experiencePhones;
  final List<String> regionPhonesWithoutDate;
  final List<String> phonesWithoutDate;
  final List<String> allPhones;

  @override
  List<Object> get props => [
        index,
        experienceToSearch,
        experienceRegionPhones,
        experiencePhones,
        regionPhonesWithoutDate,
        phonesWithoutDate,
        allPhones,
      ];
}
