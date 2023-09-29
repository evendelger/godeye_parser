import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:phone_corrector/domain/api/api.dart';
import 'package:phone_corrector/domain/data/data_provider/data_provider.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/repositories/phones_repository.dart';

part 'files_event.dart';
part 'files_state.dart';

class FilesBloc extends Bloc<FilesEvent, FilesState> {
  final dataRepository = PhonesDataRepository(
    apiClient: VoxlinkApiClient(dio: Dio()),
    dataProvider: const DataProvider(),
  );

  FilesBloc() : super(FilesState.init()) {
    on<ClearList>(_clearList);
    on<ClearItem>(_clearItem);
    on<AddItems>(_addItems);
    on<SearchByRegion>(_searchByRegion);
    on<SearchByCity>(_searchByCity);
    on<SearchByExperience>(_searchByExperience);
  }

  void _clearList(ClearList event, Emitter<FilesState> emit) {
    state.models.clear();
    state.models.addAll(List<PersonFileModel>.generate(
      5,
      (_) => PersonFileModel.empty(),
      growable: true,
    ));
    emit(FilesState(models: state.models));
  }

  void _addItems(AddItems event, Emitter<FilesState> emit) {
    if (event.count == 1) {
      state.models.add(PersonFileModel.empty());
    } else {
      state.models.addAll(List<PersonFileModel>.generate(
        event.count,
        (_) => PersonFileModel.empty(),
        growable: true,
      ));
    }
    emit(FilesState(models: state.models));
  }

  void _clearItem(ClearItem event, Emitter<FilesState> emit) {
    state.models[event.index] = PersonFileModel.empty();
    emit(FilesState(models: state.models));
  }

  Future<void> _examineFile(int index, [String? name]) async {
    state.models[index] =
        await dataRepository.getDataFromFile(name ?? state.models[index].name);
  }

  Future<void> _searchByRegion(
    SearchByRegion event,
    Emitter<FilesState> emit,
  ) async {
    if (event.name != state.models[event.index].name ||
        !state.models[event.index].fileWasExamined) {
      state.models[event.index] = state.models[event.index].copyWith(
        name: event.name,
      );
      await _examineFile(event.index);
    }
    if (!state.models[event.index].fileFounded) {
      state.models[event.index].stateModel.regionStatus = SearchStatus.error;
      emit(FilesState(models: state.models));
      return;
    }
    state.models[event.index].stateModel.regionStatus = SearchStatus.inProgress;
    emit(FilesState(models: state.models));

    final correctedPhones = await dataRepository.searchByRegion(
      state.models[event.index],
      event.region,
    );
    state.models[event.index].stateModel.regionPhones = correctedPhones;
    state.models[event.index].stateModel.regionStatus = SearchStatus.success;
    emit(FilesState(models: state.models));
  }

  Future<void> _searchByCity(
    SearchByCity event,
    Emitter<FilesState> emit,
  ) async {
    if (!state.models[event.index].fileWasExamined) {
      await _examineFile(event.index, event.name);
    }
    if (!state.models[event.index].fileFounded) {
      state.models[event.index].stateModel.cityStatus = SearchStatus.error;
      emit(FilesState(models: state.models));
      return;
    }

    final phonesTuple =
        dataRepository.searchByCity(state.models[event.index], event.city);

    state.models[event.index].stateModel.cityRegionPhones = phonesTuple.$1;
    state.models[event.index].stateModel.cityPhones = phonesTuple.$2;
    state.models[event.index].stateModel.cityStatus = SearchStatus.success;
    emit(FilesState(models: state.models));
  }

  Future<void> _searchByExperience(
    SearchByExperience event,
    Emitter<FilesState> emit,
  ) async {
    if (!state.models[event.index].fileWasExamined) {
      await _examineFile(event.index, event.name);
    }
    if (!state.models[event.index].fileFounded) {
      state.models[event.index].stateModel.experienceStatus =
          SearchStatus.error;
      emit(FilesState(models: state.models));
      return;
    }
    state.models[event.index].stateModel.experienceToSearch = event.experience;
    final phonesTuple = dataRepository.searchByExperience(
        state.models[event.index], event.experience);

    state.models[event.index].stateModel.experienceRegionPhones =
        phonesTuple.$1;
    state.models[event.index].stateModel.experiencePhones = phonesTuple.$2;

    state.models[event.index].stateModel.experienceStatus =
        SearchStatus.success;
    emit(FilesState(models: state.models));
  }
}
