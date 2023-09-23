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
    on<ChangeName>(_changeName);
    on<ClearList>(_clearList);
    on<ClearItem>(_clearItem);
    on<AddItems>(_addItems);
    on<SearchByRegion>(_searchByRegion);
  }

  void _changeName(ChangeName event, Emitter<FilesState> emit) {
    state.models[event.index] =
        state.models[event.index].copyWith(name: event.name);
  }

  void _clearList(ClearList event, Emitter<FilesState> emit) {
    state.models.clear();
    state.models.addAll(List<PersonFileModel>.filled(
      5,
      PersonFileModel.empty(),
      growable: true,
    ));
  }

  void _addItems(AddItems event, Emitter<FilesState> emit) {
    if (event.count == 1) {
      state.models.add(PersonFileModel.empty());
    } else {
      state.models.addAll(List<PersonFileModel>.filled(
        event.count,
        PersonFileModel.empty(),
        growable: true,
      ));
    }
  }

  void _clearItem(ClearItem event, Emitter<FilesState> emit) {
    state.models[event.index] = PersonFileModel.empty();
  }

  Future<void> _examineFile(int index) async {
    state.models[index] =
        await dataRepository.getDataFromFile(state.models[index].name);
  }

  Future<void> _searchByRegion(
    SearchByRegion event,
    Emitter<FilesState> emit,
  ) async {
    // TODO: сделать нормальную обработку ошибок
    if (event.region.isEmpty) return;

    if (!state.models[event.index].fileWasExamined) {
      state.models[event.index] =
          state.models[event.index].copyWith(name: event.name);
      await _examineFile(event.index);
    }

    final correctedPhones = await dataRepository.searchByRegion(
        state.models[event.index], event.region);

    state.models[event.index].stateModel.regionPhones = correctedPhones;
    emit(state);
  }
}
