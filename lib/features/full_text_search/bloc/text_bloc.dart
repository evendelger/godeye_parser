import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:phone_corrector/repositories/abstract_phones_repository.dart';

part 'text_event.dart';
part 'text_state.dart';

class TextBloc extends Bloc<TextEvent, TextState> {
  TextBloc({required this.phonesRepository}) : super(TextInitial()) {
    on<SearchByRegion>(_searchByRegion);
  }

  final AbstractPhonesDataRepository phonesRepository;

  Future<void> _searchByRegion(
    SearchByRegion event,
    Emitter<TextState> emit,
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
