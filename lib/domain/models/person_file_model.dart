import 'package:equatable/equatable.dart';
import 'package:phone_corrector/domain/models/models.dart';

class PersonFileModel extends Equatable {
  const PersonFileModel({
    required this.name,
    this.allPhones,
    this.allPersonModels,
    required this.stateModel,
    required this.fileFounded,
  });

  final String name;
  final List<String>? allPhones;
  final List<SinglePersonModel>? allPersonModels;
  final PersonStateModel stateModel;
  final bool fileFounded;

  bool get fileWasExamined => allPhones != null && allPersonModels != null;

  factory PersonFileModel.empty({String? name}) {
    return PersonFileModel(
      name: '',
      allPhones: null,
      allPersonModels: null,
      stateModel: PersonStateModel(),
      fileFounded: false,
    );
  }

  @override
  List<Object?> get props => [
        name,
        ...?allPhones,
        ...?allPersonModels,
        stateModel,
        fileFounded,
      ];

  PersonFileModel copyWith({
    String? name,
    List<String>? allPhones,
    List<SinglePersonModel>? allPersonModels,
    PersonStateModel? stateModel,
    bool? fileFounded,
  }) {
    return PersonFileModel(
      name: name ?? this.name,
      allPhones: allPhones ?? this.allPhones,
      allPersonModels: allPersonModels ?? this.allPersonModels,
      stateModel: stateModel ?? this.stateModel,
      fileFounded: fileFounded ?? this.fileFounded,
    );
  }
}
