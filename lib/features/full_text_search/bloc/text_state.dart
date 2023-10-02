part of 'text_bloc.dart';

sealed class TextState extends Equatable {
  const TextState();
  @override
  List<Object?> get props => [];
}

final class TextInitial extends TextState {}

final class TextLoading extends TextState {}

final class TextLoaded extends TextState {
  const TextLoaded({required this.allPhones, required this.correctedPhones});

  final List<String> allPhones;
  final List<String> correctedPhones;

  @override
  List<Object?> get props => [correctedPhones];
}

final class TextLoadingFailure extends TextState {}
