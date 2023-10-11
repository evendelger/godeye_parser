import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/repositories/repositories.dart';

part 'mini_search_event.dart';
part 'mini_search_state.dart';

class MiniSearchBloc extends Bloc<MiniSearchEvent, MiniSearchState> {
  MiniSearchBloc({required this.phonesRepository})
      : super(MiniSearchInitial(model: PersonFileModel.empty())) {
    on<ClearData>(_clearData);
    on<SearchByRegion>(_searchByRegion);
    on<SearchByCity>(_searchByCity);
    on<SearchByExperience>(_searchByExperience);
    on<ShowRegionData>(_showRegionData);
    on<ShowCityData>(_showCityData);
    on<ShowExperienceData>(_showExperienceData);
  }

  final AbstractPhonesDataRepository phonesRepository;

  Future<PersonFileModel> _examineFile(String name) async {
    return await phonesRepository.getDataFromFile(name);
  }

  void _clearData(
    ClearData event,
    Emitter<MiniSearchState> emit,
  ) {
    emit(MiniSearchInitial(model: PersonFileModel.empty()));
  }

  Future<void> _searchByRegion(
    SearchByRegion event,
    Emitter<MiniSearchState> emit,
  ) async {
    var localModel = state.model;

    if (event.name != localModel.name || !state.model.fileWasExamined) {
      final newStatus = state.model.stateModel.statuses
          .copyWith(regionStatus: SearchStatus.inProgress);
      localModel.stateModel.statuses = newStatus;

      emit(MiniSearchInProgress(model: localModel));
      localModel = await _examineFile(event.name);
    }

    if (!localModel.fileFounded) {
      final newStatus = localModel.stateModel.statuses
          .copyWith(regionStatus: SearchStatus.error);
      localModel.stateModel.statuses = newStatus;

      emit(MiniSearchFailed(model: localModel));
      return;
    }
    var newStatus = state.model.stateModel.statuses
        .copyWith(regionStatus: SearchStatus.inProgress);
    localModel.stateModel.statuses = newStatus;
    localModel.stateModel.regionToSearch = event.region;
    emit(MiniSearchInProgress(model: localModel));

    final correctedPhones = phonesRepository.searchByRegion(
      state.model,
      event.region,
    );

    newStatus = localModel.stateModel.statuses
        .copyWith(regionStatus: SearchStatus.success);
    localModel.stateModel.regionPhones = correctedPhones;
    localModel.stateModel.statuses = newStatus;

    emit(MiniSearchRegionInfo(
      model: localModel,
      regionPhones: localModel.stateModel.regionPhones!,
      allPhones: localModel.allPhones!,
    ));
  }

  Future<void> _searchByCity(
    SearchByCity event,
    Emitter<MiniSearchState> emit,
  ) async {
    var localModel = state.model;

    if (localModel.name != event.name || !localModel.fileWasExamined) {
      final newStatus = state.model.stateModel.statuses
          .copyWith(cityStatus: SearchStatus.inProgress);
      localModel.stateModel.statuses = newStatus;

      emit(MiniSearchInProgress(model: localModel));
      localModel = await _examineFile(event.name);
    }

    if (!localModel.fileFounded) {
      final newStatus = state.model.stateModel.statuses
          .copyWith(cityStatus: SearchStatus.error);
      localModel.stateModel.statuses = newStatus;

      emit(MiniSearchFailed(model: localModel));
      return;
    }

    final phonesTuple = phonesRepository.searchByCity(state.model, event.city);

    localModel.stateModel.cityRegionPhones = phonesTuple.$1;
    localModel.stateModel.cityPhones = phonesTuple.$2;
    localModel.stateModel.statuses = localModel.stateModel.statuses
        .copyWith(cityStatus: SearchStatus.success);

    emit(MiniSearchCityInfo(
      model: localModel,
      cityRegionPhones: localModel.stateModel.cityRegionPhones!,
      cityPhones: localModel.stateModel.cityPhones!,
      allPhones: localModel.allPhones!,
    ));
  }

  Future<void> _searchByExperience(
    SearchByExperience event,
    Emitter<MiniSearchState> emit,
  ) async {
    var localModel = state.model;

    if (localModel.name != event.name || !localModel.fileWasExamined) {
      final newStatus = state.model.stateModel.statuses
          .copyWith(experienceStatus: SearchStatus.inProgress);
      localModel.stateModel.statuses = newStatus;

      emit(MiniSearchInProgress(model: localModel));
      localModel = await _examineFile(event.name);
    }

    if (!localModel.fileFounded) {
      final newStatus = state.model.stateModel.statuses
          .copyWith(experienceStatus: SearchStatus.error);
      localModel.stateModel.statuses = newStatus;

      emit(MiniSearchFailed(model: localModel));
      return;
    }
    localModel.stateModel.experienceToSearch = event.experience;

    final phonesTuple =
        phonesRepository.searchByExperience(state.model, event.experience);

    localModel.stateModel.experienceRegionPhones = phonesTuple.$1;
    localModel.stateModel.experiencePhones = phonesTuple.$2;

    localModel.stateModel.statuses = state.model.stateModel.statuses
        .copyWith(experienceStatus: SearchStatus.success);

    emit(MiniSearchExperienceInfo(
      allPhones: localModel.allPhones!,
      model: localModel,
      experienceToSearch: event.experience,
      experienceRegionPhones: localModel.stateModel.experienceRegionPhones!,
      experiencePhones: localModel.stateModel.experiencePhones!,
    ));
  }

  void _showRegionData(
    ShowRegionData event,
    Emitter<MiniSearchState> emit,
  ) {
    if (state.model.allPhones == null ||
        state.model.stateModel.regionPhones == null) {
      emit(MiniSearchInitial(model: state.model));
      return;
    }
    emit(MiniSearchRegionInfo(
      model: state.model,
      regionPhones: state.model.stateModel.regionPhones!,
      allPhones: state.model.allPhones!,
    ));
  }

  void _showCityData(
    ShowCityData event,
    Emitter<MiniSearchState> emit,
  ) {
    if (state.model.allPhones == null ||
        state.model.stateModel.experienceToSearch == null ||
        state.model.stateModel.cityRegionPhones == null ||
        state.model.stateModel.cityPhones == null) {
      emit(MiniSearchInitial(model: state.model));
      return;
    }
    emit(MiniSearchCityInfo(
      model: state.model,
      allPhones: state.model.allPhones!,
      cityRegionPhones: state.model.stateModel.cityRegionPhones!,
      cityPhones: state.model.stateModel.cityPhones!,
    ));
  }

  void _showExperienceData(
    ShowExperienceData event,
    Emitter<MiniSearchState> emit,
  ) {
    if (state.model.allPhones == null ||
        state.model.stateModel.experienceToSearch == null ||
        state.model.stateModel.experienceRegionPhones == null ||
        state.model.stateModel.experiencePhones == null) {
      emit(MiniSearchInitial(model: state.model));
      return;
    }
    emit(MiniSearchExperienceInfo(
      model: state.model,
      allPhones: state.model.allPhones!,
      experienceToSearch: state.model.stateModel.experienceToSearch!,
      experienceRegionPhones: state.model.stateModel.experienceRegionPhones!,
      experiencePhones: state.model.stateModel.experiencePhones!,
    ));
  }
}