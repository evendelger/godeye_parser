import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/repositories/abstract_phones_repository.dart';

part 'file_search_event.dart';
part 'file_search_state.dart';

class FileSearchBloc extends Bloc<FileSearchEvent, FileSearchState> {
  FileSearchBloc({required this.phonesRepository})
      : super(FileSearchState.init()) {
    on<ClearList>(_clearList);
    on<ClearItem>(_clearItem);
    on<AddItems>(_addItems);
    on<SearchByRegion>(_searchByRegion);
    on<SearchByCity>(_searchByCity);
    on<SearchByExperience>(_searchByExperience);
  }

  final AbstractPhonesDataRepository phonesRepository;

  void _clearList(ClearList event, Emitter<FileSearchState> emit) {
    state.models.clear();
    state.models.addAll(List<PersonFileModel>.generate(
      5,
      (_) => PersonFileModel.empty(),
      growable: true,
    ));
    emit(FileSearchState(models: state.models));
  }

  void _addItems(AddItems event, Emitter<FileSearchState> emit) {
    if (event.count == 1) {
      state.models.add(PersonFileModel.empty());
    } else {
      state.models.addAll(List<PersonFileModel>.generate(
        event.count,
        (_) => PersonFileModel.empty(),
        growable: true,
      ));
    }
    emit(FileSearchState(models: state.models));
  }

  void _clearItem(ClearItem event, Emitter<FileSearchState> emit) {
    state.models[event.index] = PersonFileModel.empty();
    emit(FileSearchState(models: state.models));
  }

  Future<void> _examineFile(int index, [String? name]) async {
    state.models[index] = await phonesRepository
        .getDataFromFile(name ?? state.models[index].name);
  }

  Future<void> _searchByRegion(
    SearchByRegion event,
    Emitter<FileSearchState> emit,
  ) async {
    if (event.name != state.models[event.index].name ||
        !state.models[event.index].fileWasExamined) {
      state.models[event.index] = state.models[event.index].copyWith(
        name: event.name,
      );
      state.models[event.index].stateModel.statuses = state
          .models[event.index].stateModel.statuses
          .copyWith(regionStatus: SearchStatus.inProgress);

      emit(FilesSingleState(
        models: state.models,
        model: state.models[event.index],
        index: event.index,
      ));
      await _examineFile(event.index, event.name);
    }
    if (!state.models[event.index].fileFounded) {
      state.models[event.index].stateModel.statuses = state
          .models[event.index].stateModel.statuses
          .copyWith(regionStatus: SearchStatus.error);
      emit(FilesStatusMessage(models: state.models, message: "Файл не найден"));
      return;
    }
    state.models[event.index].stateModel.statuses = state
        .models[event.index].stateModel.statuses
        .copyWith(regionStatus: SearchStatus.inProgress);
    state.models[event.index].stateModel.regionToSearch = event.region;
    emit(FilesSingleState(
      models: state.models,
      model: state.models[event.index],
      index: event.index,
    ));

    final correctedPhones = phonesRepository.searchByRegion(
      state.models[event.index],
      event.region,
    );
    state.models[event.index].stateModel.regionPhones = correctedPhones;
    state.models[event.index].stateModel.statuses = state
        .models[event.index].stateModel.statuses
        .copyWith(regionStatus: SearchStatus.success);

    emit(FilesSingleState(
      models: state.models,
      model: state.models[event.index],
      index: event.index,
    ));
  }

  Future<void> _searchByCity(
    SearchByCity event,
    Emitter<FileSearchState> emit,
  ) async {
    if (!state.models[event.index].fileWasExamined) {
      state.models[event.index].stateModel.statuses = state
          .models[event.index].stateModel.statuses
          .copyWith(cityStatus: SearchStatus.inProgress);
      emit(FilesSingleState(
        models: state.models,
        model: state.models[event.index],
        index: event.index,
      ));
      await _examineFile(event.index, event.name);
    }
    if (!state.models[event.index].fileFounded) {
      state.models[event.index].stateModel.statuses = state
          .models[event.index].stateModel.statuses
          .copyWith(cityStatus: SearchStatus.error);
      emit(FilesStatusMessage(models: state.models, message: "Файл не найден"));
      return;
    }

    final phonesTuple =
        phonesRepository.searchByCity(state.models[event.index], event.city);

    state.models[event.index].stateModel.cityRegionPhones = phonesTuple.$1;
    state.models[event.index].stateModel.cityPhones = phonesTuple.$2;
    state.models[event.index].stateModel.statuses = state
        .models[event.index].stateModel.statuses
        .copyWith(cityStatus: SearchStatus.success);
    emit(FilesSingleState(
      models: state.models,
      model: state.models[event.index],
      index: event.index,
    ));
  }

  Future<void> _searchByExperience(
    SearchByExperience event,
    Emitter<FileSearchState> emit,
  ) async {
    if (!state.models[event.index].fileWasExamined) {
      state.models[event.index].stateModel.statuses = state
          .models[event.index].stateModel.statuses
          .copyWith(experienceStatus: SearchStatus.inProgress);
      emit(FilesSingleState(
        models: state.models,
        model: state.models[event.index],
        index: event.index,
      ));
      await _examineFile(event.index, event.name);
    }
    if (!state.models[event.index].fileFounded) {
      state.models[event.index].stateModel.statuses = state
          .models[event.index].stateModel.statuses
          .copyWith(experienceStatus: SearchStatus.error);
      emit(FilesStatusMessage(models: state.models, message: "Файл не найден"));
      return;
    }
    state.models[event.index].stateModel.experienceToSearch = event.experience;
    final phonesTuple = phonesRepository.searchByExperience(
        state.models[event.index], event.experience);

    state.models[event.index].stateModel.experienceRegionPhones =
        phonesTuple.$1;
    state.models[event.index].stateModel.experiencePhones = phonesTuple.$2;

    state.models[event.index].stateModel.statuses = state
        .models[event.index].stateModel.statuses
        .copyWith(experienceStatus: SearchStatus.success);

    emit(FilesSingleState(
      models: state.models,
      model: state.models[event.index],
      index: event.index,
    ));
  }
}
