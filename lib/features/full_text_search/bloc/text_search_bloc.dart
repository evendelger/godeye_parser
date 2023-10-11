import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:phone_corrector/repositories/abstract_phones_repository.dart';

part 'text_search_event.dart';
part 'text_search_state.dart';

class TextSearchBloc extends Bloc<TextSearchEvent, TextSearchState> {
  TextSearchBloc({required this.phonesRepository}) : super(TextInitial()) {
    on<SearchByRegion>(_searchByRegion);
  }

  final AbstractPhonesDataRepository phonesRepository;

  Future<void> _searchByRegion(
    SearchByRegion event,
    Emitter<TextSearchState> emit,
  ) async {
    try {
      emit(TextLoading());
      final phonesTuple =
          await phonesRepository.searchByText(event.text, event.region);
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
