part of 'mini_search_bloc.dart';

sealed class MiniSearchEvent extends Equatable {
  const MiniSearchEvent();

  @override
  List<Object> get props => [];
}

final class ClearData extends MiniSearchEvent {
  const ClearData();
}

final class SearchByRegion extends MiniSearchEvent {
  const SearchByRegion({
    required this.name,
    required this.region,
  });

  final String name;
  final String region;

  @override
  List<Object> get props => [name, region];
}

final class SearchByCity extends MiniSearchEvent {
  const SearchByCity({
    required this.name,
    required this.city,
  });

  final String name;
  final String city;

  @override
  List<Object> get props => [name, city];
}

final class SearchByExperience extends MiniSearchEvent {
  const SearchByExperience({
    required this.name,
    required this.experience,
  });

  final String name;
  final String experience;

  @override
  List<Object> get props => [name, experience];
}

final class ShowRegionData extends MiniSearchEvent {
  const ShowRegionData();
}

final class ShowCityData extends MiniSearchEvent {
  const ShowCityData();
}

final class ShowExperienceData extends MiniSearchEvent {
  const ShowExperienceData();
}
