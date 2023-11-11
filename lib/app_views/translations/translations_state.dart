part of 'translations_bloc.dart';

final class TranslationsState extends Equatable {
  const TranslationsState({
    this.classifications = const {},
    this.colors = const {},
    this.occasions = const {},
  });

  final Map<String, EsnapClassificationTranslation> classifications;
  final Map<String, EsnapColorTranslation> colors;
  final Map<String, EsnapOccasionTranslation> occasions;

  TranslationsState copyWith({
    Map<String, EsnapClassificationTranslation>? classifications,
    Map<String, EsnapColorTranslation>? colors,
    Map<String, EsnapOccasionTranslation>? occasions,
  }) {
    return TranslationsState(
      classifications: classifications ?? this.classifications,
      colors: colors ?? this.colors,
      occasions: occasions ?? this.occasions,
    );
  }

  @override
  List<Object?> get props => [
        classifications,
        colors,
        occasions,
      ];
}
