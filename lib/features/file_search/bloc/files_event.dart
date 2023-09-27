part of 'files_bloc.dart';

sealed class FilesEvent extends Equatable {
  const FilesEvent();

  @override
  List<Object> get props => [];
}

final class ClearList extends FilesEvent {
  const ClearList();
}

final class ClearItem extends FilesEvent {
  const ClearItem({required this.index});

  final int index;

  @override
  List<Object> get props => [index];
}

final class AddItems extends FilesEvent {
  const AddItems({required this.count});

  final int count;

  @override
  List<Object> get props => [count];
}

final class SearchByRegion extends FilesEvent {
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

final class SearchByCity extends FilesEvent {
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

final class SearchByExperience extends FilesEvent {
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
