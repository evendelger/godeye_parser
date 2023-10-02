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

class FilesStatusMessage extends FileSearchState {
  const FilesStatusMessage({required super.models, required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
