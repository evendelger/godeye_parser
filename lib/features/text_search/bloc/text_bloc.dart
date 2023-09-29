import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:phone_corrector/domain/api/api.dart';
import 'package:phone_corrector/domain/data/data_provider/data_provider.dart';
import 'package:phone_corrector/repositories/phones_repository.dart';

part 'text_event.dart';
part 'text_state.dart';

class TextBloc extends Bloc<TextEvent, TextState> {
  final dataRepository = PhonesDataRepository(
    apiClient: VoxlinkApiClient(dio: Dio()),
    dataProvider: const DataProvider(),
  );

  TextBloc() : super(TextInitial()) {
    on<SearchByRegion>(_searchByRegion);
  }

  Future<void> _searchByRegion(
    SearchByRegion event,
    Emitter<TextState> emit,
  ) async {
    try {
      emit(TextLoading());
      final phonesTuple =
          await dataRepository.searchByText(event.text, event.region);
      emit(TextLoaded(
        correctedPhones: phonesTuple.$1,
        allPhones: phonesTuple.$2,
      ));
    } catch (e) {
      log(e.toString());
      emit(TextLoadingFailure());
    }
  }
}
