/// Classification seed data
class ClassificationTypeSeed {
  /// Basic constructor
  const ClassificationTypeSeed({
    required this.name,
    required this.en,
    required this.es,
  });

  /// The original name of the classification
  final String name;

  /// The english name of the classification
  final String en;

  /// The spanish name of the classification
  final String es;
}

/// Seeds for the classification types
const classificationTypeSeeds = [
  ClassificationTypeSeed(
    name: 'Top',
    en: 'Top',
    es: 'Parte superior',
  ),
  ClassificationTypeSeed(
    name: 'Bottom',
    en: 'Bottom',
    es: 'Parte inferior',
  ),
  ClassificationTypeSeed(
    name: 'Shoes',
    en: 'Shoes',
    es: 'Calzado',
  ),
  ClassificationTypeSeed(
    name: 'Other',
    en: 'Other',
    es: 'Otro',
  ),
];
