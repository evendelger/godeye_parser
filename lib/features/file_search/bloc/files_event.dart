part of 'files_bloc.dart';

sealed class FilesEvent extends Equatable {
  const FilesEvent();

  @override
  List<Object> get props => [];
}

final class ChangeName extends FilesEvent {
  const ChangeName({required this.index, required this.name});

  final int index;
  final String name;

  @override
  List<Object> get props => [index, name];
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
  List<Object> get props => [region];
}
