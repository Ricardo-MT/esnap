part of 'translations_bloc.dart';

sealed class TranslationsEvent extends Equatable {
  const TranslationsEvent();

  @override
  List<Object> get props => [];
}

final class TranslationsLanguageChanged extends TranslationsEvent {
  const TranslationsLanguageChanged({
    required this.languageCode,
  });

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}
