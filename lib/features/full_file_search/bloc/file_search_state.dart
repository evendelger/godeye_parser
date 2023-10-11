part of 'file_search_bloc.dart';

class FileSearchState extends Equatable {
  const FileSearchState({required this.models});

  final List<PersonFileModel> models;

  factory FileSearchState.init() {
    return FileSearchState(
      models: List<PersonFileModel>.generate(
        5,
        (_) => PersonFileModel.empty(),
        growable: true,
      ),
    );
  }

  FileSearchState copyWith({
    List<PersonFileModel>? models,
  }) {
    return FileSearchState(
      models: models ?? this.models,
    );
  }

  @override
  List<Object?> get props => [models];
}

// для МНОГОКРАТНОГО уменьшения ребилдов иконок статуса
class FilesSingleState extends FileSearchState {
  const FilesSingleState({
    required super.models,
    required this.model,
    required this.index,
  });

  final int index;
  final PersonFileModel model;

  @override
  List<Object?> get props => [index, model];
}

class FilesStatusMessage extends FileSearchState {
  const FilesStatusMessage({required super.models, required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
