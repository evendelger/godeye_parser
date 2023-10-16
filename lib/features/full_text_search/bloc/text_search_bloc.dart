import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:godeye_parser/repositories/abstract_phones_repository.dart';

part 'text_search_event.dart';
part 'text_search_state.dart';

class TextSearchBloc extends Bloc<TextSearchEvent, TextSearchState> {
  TextSearchBloc({required this.phonesRepository}) : super(TextInitial()) {
    on<SearchByRegion>(_searchByRegion);
  }

  final AbstractPhonesDataRepository phonesRepository;

  void _searchByRegion(
    SearchByRegion event,
    Emitter<TextSearchState> emit,
  ) {
    emit(TextLoading());
    final phonesTuple = phonesRepository.searchByText(event.text, event.region);
    emit(TextLoaded(
      correctedPhones: phonesTuple.$1,
      allPhones: phonesTuple.$2,
    ));
  }
}
