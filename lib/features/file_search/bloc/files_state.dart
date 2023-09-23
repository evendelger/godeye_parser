part of 'files_bloc.dart';

class FilesState extends Equatable {
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

  @override
  List<Object?> get props => [...models];
}
