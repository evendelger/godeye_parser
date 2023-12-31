import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:godeye_parser/domain/domain.dart';
import 'package:godeye_parser/features/full_file_search/full_file_search.dart';

part 'full_search_event.dart';
part 'full_search_state.dart';

class FullSearchBloc extends Bloc<FullSearchEvent, FullSearchState> {
  FullSearchBloc({required this.phonesRepository})
      // инициализирую 200 моделей, потому что просто НЕ НАШЕЛ другого
      // способа изменить количество моделей в стейте или изменить сам стейт
      // чтобы блок этот стейт не запускал, т.е. он просто игнорирует все ограничения
      // понимаю, что это ОЧЕНЬ плохое решение, но спустя 5-6 часов я так и не нашел другого способа
      // чтобы приложение просто работало и не крашилось из-за говно-блока, видимо стоит попробовать riverpod :)
      : super(FullSearchState.init(200)) {
    on<SetupState>(_setupState);
    on<ClearList>(_clearList);
    on<ClearItem>(_clearItem);
    on<AddItems>(_addItems);
    on<SearchByRegion>(_searchByRegion);
    on<SearchByCity>(_searchByCity);
    on<SearchByExperience>(_searchByExperience);
    on<ShowRegionData>(_showRegionData);
    on<ShowCityData>(_showCityData);
    on<ShowExperienceData>(_showExperienceData);
  }

  final AbstractPhonesDataRepository phonesRepository;

  void _setupState(SetupState event, Emitter<FullSearchState> emit) async {
    emit(FullSearchState.init(event.length));
  }

  void _clearList(ClearList event, Emitter<FullSearchState> emit) {
    state.models.clear();
    state.models.addAll(List<PersonFileModel>.generate(
      5,
      (_) => PersonFileModel.empty(),
      growable: true,
    ));
    emit(FullSearchState(models: state.models));
  }

  void _addItems(AddItems event, Emitter<FullSearchState> emit) {
    if (event.count == 1) {
      state.models.add(PersonFileModel.empty());
    } else {
      state.models.addAll(List<PersonFileModel>.generate(
        event.count,
        (_) => PersonFileModel.empty(),
        growable: true,
      ));
    }
    emit(FullSearchState(models: state.models));
  }

  void _clearItem(ClearItem event, Emitter<FullSearchState> emit) {
    state.models[event.index] = PersonFileModel.empty();
    emit(FullSearchState(models: state.models));
  }

  Future<(bool, PersonFileModel)> _takeActions(
    String name,
    int index,
    List<PersonFileModel> localList,
    PersonFileModel localModel,
  ) async {
    var isFailed = false;
    if (name != localModel.name || !localModel.fileWasExamined) {
      final newStatus = localModel.stateModel.statuses
          .copyWith(regionStatus: SearchStatus.inProgress);
      localModel.stateModel.statuses = newStatus;
      localList[index] = localModel;
      localModel = await _examineFile(index, name);
    }
    if (!localModel.fileFounded) {
      final newStatus = localModel.stateModel.statuses
          .copyWith(regionStatus: SearchStatus.error);
      localModel.stateModel.statuses = newStatus;
      localList[index] = localModel;
      isFailed = true;
    }
    return (isFailed, localModel);
  }

  Future<PersonFileModel> _examineFile(int index, [String? name]) async {
    return await phonesRepository
        .getDataFromFile(name ?? state.models[index].name);
  }

  Future<void> _searchByRegion(
    SearchByRegion event,
    Emitter<FullSearchState> emit,
  ) async {
    var localModel = state.models[event.index];
    var localList = state.models;
    emit(FileSearchInProgress(
        models: localList, index: event.index, searchType: SearchType.region));

    final resultOfAction =
        await _takeActions(event.name, event.index, localList, localModel);
    localModel = resultOfAction.$2;
    final isFailed = resultOfAction.$1;

    if (isFailed) {
      localList[event.index] = localModel;
      emit(FileSearchFailed(
          models: localList,
          index: event.index,
          searchType: SearchType.region));
      return;
    }

    var newStatus = localModel.stateModel.statuses
        .copyWith(regionStatus: SearchStatus.inProgress);
    localModel.stateModel.statuses = newStatus;
    localModel.stateModel.regionToSearch = event.region;
    localList[event.index] = localModel;
    emit(FileSearchInProgress(
        models: localList, index: event.index, searchType: SearchType.region));
    emit(FileSearchInProgress(
        models: localList, index: event.index, searchType: SearchType.region));

    final correctedPhones = phonesRepository.searchByRegion(
      localModel,
      event.region,
    );

    newStatus = localModel.stateModel.statuses
        .copyWith(regionStatus: SearchStatus.success);
    localModel.stateModel.regionPhones = correctedPhones;
    localModel.stateModel.statuses = newStatus;
    localList[event.index] = localModel;

    emit(FileSearchRegionInfo(
      index: event.index,
      models: localList,
      regionPhones: localModel.stateModel.regionPhones!,
      allPhones: localModel.allPhones!,
    ));
  }

  Future<void> _searchByCity(
    SearchByCity event,
    Emitter<FullSearchState> emit,
  ) async {
    var localModel = state.models[event.index];
    var localList = state.models;

    emit(FileSearchInProgress(
        models: localList, index: event.index, searchType: SearchType.city));

    final resultOfAction =
        await _takeActions(event.name, event.index, localList, localModel);
    localModel = resultOfAction.$2;
    final isFailed = resultOfAction.$1;

    if (isFailed) {
      localList[event.index] = localModel;
      emit(FileSearchFailed(
          models: localList, index: event.index, searchType: SearchType.city));
      return;
    }

    final phonesTuple =
        phonesRepository.searchByCity(state.models[event.index], event.city);

    localModel.stateModel.cityRegionPhones = phonesTuple.$1;
    localModel.stateModel.cityPhones = phonesTuple.$2;
    localModel.stateModel.statuses = localModel.stateModel.statuses
        .copyWith(cityStatus: SearchStatus.success);
    localList[event.index] = localModel;

    emit(FileSearchCityInfo(
      index: event.index,
      models: localList,
      cityRegionPhones: localModel.stateModel.cityRegionPhones!,
      cityPhones: localModel.stateModel.cityPhones!,
      allPhones: localModel.allPhones!,
    ));
  }

  Future<void> _searchByExperience(
    SearchByExperience event,
    Emitter<FullSearchState> emit,
  ) async {
    var localModel = state.models[event.index];
    var localList = state.models;

    emit(FileSearchInProgress(
        models: localList,
        index: event.index,
        searchType: SearchType.experience));

    final resultOfAction =
        await _takeActions(event.name, event.index, localList, localModel);
    localModel = resultOfAction.$2;
    final isFailed = resultOfAction.$1;

    if (isFailed) {
      localList[event.index] = localModel;
      emit(FileSearchFailed(
          models: localList,
          index: event.index,
          searchType: SearchType.experience));
      return;
    }
    localModel.stateModel.experienceToSearch = event.experience;

    final phonesTuple =
        phonesRepository.searchByExperience(localModel, event.experience);

    localModel.stateModel.experienceRegionPhones = phonesTuple.$1;
    localModel.stateModel.experiencePhones = phonesTuple.$2;

    final regionPhonesWithoutDate = <String>[];
    if (localModel.stateModel.regionPhones != null) {
      for (var regionPhone in localModel.stateModel.regionPhones!) {
        final correctModel = localModel.allPersonModels!.firstWhere(
            (model) => model.phoneNumbersList.contains(regionPhone));
        if (correctModel.dateOfBirth == null) {
          regionPhonesWithoutDate.add(regionPhone);
        }
      }
    }

    final phonesWithoutDate = <String>[];
    for (var model in localModel.allPersonModels!) {
      if (model.dateOfBirth == null) {
        final copyOfList = model.phoneNumbersList;
        copyOfList.removeAll(regionPhonesWithoutDate);
        phonesWithoutDate.addAll(copyOfList);
      }
    }

    localModel.stateModel.phonesWithoutDate = phonesWithoutDate;
    localModel.stateModel.regionPhonesWithoutDate = regionPhonesWithoutDate;
    localModel.stateModel.statuses = localModel.stateModel.statuses
        .copyWith(experienceStatus: SearchStatus.success);
    localList[event.index] = localModel;

    emit(FileSearchExperienceInfo(
      index: event.index,
      models: localList,
      experienceToSearch: event.experience,
      experienceRegionPhones: localModel.stateModel.experienceRegionPhones!,
      experiencePhones: localModel.stateModel.experiencePhones!,
      phonesWithoutDate: localModel.stateModel.phonesWithoutDate!,
      allPhones: localModel.allPhones!,
      regionPhonesWithoutDate: regionPhonesWithoutDate,
    ));
  }

  void _showRegionData(
    ShowRegionData event,
    Emitter<FullSearchState> emit,
  ) {
    final model = state.models[event.index];
    if (model.allPhones == null || model.stateModel.regionPhones == null) {
      emit(FileSearchEmpty(models: state.models));
      return;
    }
    emit(FileSearchRegionInfo(
      index: event.index,
      models: state.models,
      regionPhones: model.stateModel.regionPhones!,
      allPhones: model.allPhones!,
    ));
  }

  void _showCityData(
    ShowCityData event,
    Emitter<FullSearchState> emit,
  ) {
    final model = state.models[event.index];
    if (model.allPhones == null ||
        model.stateModel.cityRegionPhones == null ||
        model.stateModel.cityPhones == null) {
      emit(FileSearchEmpty(models: state.models));
      return;
    }
    emit(FileSearchCityInfo(
      index: event.index,
      models: state.models,
      cityRegionPhones: model.stateModel.cityRegionPhones!,
      cityPhones: model.stateModel.cityPhones!,
      allPhones: model.allPhones!,
    ));
  }

  void _showExperienceData(
    ShowExperienceData event,
    Emitter<FullSearchState> emit,
  ) {
    final model = state.models[event.index];
    if (model.allPhones == null ||
        model.stateModel.experienceToSearch == null ||
        model.stateModel.experienceRegionPhones == null ||
        model.stateModel.experiencePhones == null) {
      emit(FileSearchEmpty(models: state.models));
      return;
    }
    emit(FileSearchExperienceInfo(
      index: event.index,
      models: state.models,
      experienceToSearch: model.stateModel.experienceToSearch!,
      experienceRegionPhones: model.stateModel.experienceRegionPhones!,
      experiencePhones: model.stateModel.experiencePhones!,
      phonesWithoutDate: model.stateModel.phonesWithoutDate!,
      allPhones: model.allPhones!,
      regionPhonesWithoutDate: model.stateModel.regionPhonesWithoutDate!,
    ));
  }
}
