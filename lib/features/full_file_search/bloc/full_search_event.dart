part of 'full_search_bloc.dart';

sealed class FullSearchEvent extends Equatable {
  const FullSearchEvent();

  @override
  List<Object> get props => [];
}

final class ClearList extends FullSearchEvent {
  const ClearList();
}

final class ClearItem extends FullSearchEvent {
  const ClearItem({required this.index});

  final int index;

  @override
  List<Object> get props => [index];
}

final class AddItems extends FullSearchEvent {
  const AddItems({required this.count});

  final int count;

  @override
  List<Object> get props => [count];
}

final class SearchByRegion extends FullSearchEvent {
  const SearchByRegion({
    required this.index,
    required this.name,
    required this.region,
  });

  final int index;
  final String name;
  final String region;

  @override
  List<Object> get props => [index, name, region];
}

final class SearchByCity extends FullSearchEvent {
  const SearchByCity({
    required this.index,
    required this.name,
    required this.city,
  });

  final int index;
  final String name;
  final String city;

  @override
  List<Object> get props => [index, name, city];
}

final class SearchByExperience extends FullSearchEvent {
  const SearchByExperience({
    required this.index,
    required this.name,
    required this.experience,
  });

  final int index;
  final String name;
  final String experience;

  @override
  List<Object> get props => [index, name, experience];
}

final class ShowRegionData extends FullSearchEvent {
  const ShowRegionData({required this.index});

  final int index;
}

final class ShowCityData extends FullSearchEvent {
  const ShowCityData({required this.index});

  final int index;
}

final class ShowExperienceData extends FullSearchEvent {
  const ShowExperienceData({required this.index});

  final int index;
}
