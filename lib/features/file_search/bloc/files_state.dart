part of 'files_bloc.dart';

class FilesState {
  const FilesState({required this.models});

  final List<PersonFileModel> models;

  factory FilesState.init() {
    return FilesState(
      models: List<PersonFileModel>.filled(
        5,
        PersonFileModel.empty(),
        growable: true,
      ),
    );
  }

  FilesState copyWith({
    List<PersonFileModel>? models,
  }) {
    return FilesState(
      models: models ?? this.models,
    );
  }
}
