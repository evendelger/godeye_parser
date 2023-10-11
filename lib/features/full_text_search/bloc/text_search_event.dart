part of 'text_search_bloc.dart';

sealed class TextSearchEvent extends Equatable {
  const TextSearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchByRegion extends TextSearchEvent {
  const SearchByRegion({required this.text, required this.region});

  final String text;
  final String region;

  @override
  List<Object> get props => [text, region];
}
