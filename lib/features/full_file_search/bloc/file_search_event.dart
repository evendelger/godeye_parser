part of 'file_search_bloc.dart';

sealed class FileSearchEvent extends Equatable {
  const FileSearchEvent();

  @override
  List<Object> get props => [];
}

final class ClearList extends FileSearchEvent {
  const ClearList();
}

final class ClearItem extends FileSearchEvent {
  const ClearItem({required this.index});

  final int index;

  @override
  List<Object> get props => [index];
}

final class AddItems extends FileSearchEvent {
  const AddItems({required this.count});

  final int count;

  @override
  List<Object> get props => [count];
}

final class SearchByRegion extends FileSearchEvent {
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

final class SearchByCity extends FileSearchEvent {
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

final class SearchByExperience extends FileSearchEvent {
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
