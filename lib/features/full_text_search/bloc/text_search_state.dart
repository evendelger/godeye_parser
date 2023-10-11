part of 'text_search_bloc.dart';

sealed class TextSearchState extends Equatable {
  const TextSearchState();
  @override
  List<Object?> get props => [];
}

final class TextInitial extends TextSearchState {}

final class TextLoading extends TextSearchState {}

final class TextLoaded extends TextSearchState {
  const TextLoaded({required this.allPhones, required this.correctedPhones});

  final List<String> allPhones;
  final List<String> correctedPhones;

  @override
  List<Object?> get props => [correctedPhones];
}

final class TextLoadingFailure extends TextSearchState {}
