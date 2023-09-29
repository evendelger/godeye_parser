part of 'text_bloc.dart';

sealed class TextEvent extends Equatable {
  const TextEvent();

  @override
  List<Object> get props => [];
}

final class SearchByRegion extends TextEvent {
  const SearchByRegion({required this.text, required this.region});

  final String text;
  final String region;

  @override
  List<Object> get props => [text, region];
}
