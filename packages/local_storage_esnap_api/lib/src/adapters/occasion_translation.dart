import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';

part 'occasion_translation.g.dart';

/// A Hive class mimmicking the EsnapOccasionTranslation class
@HiveType(typeId: 10)
class OccasionTranslationSchema extends HiveObject {
  /// Basic constructor
  OccasionTranslationSchema({
    required this.id,
    required this.name,
    required this.occasionId,
    required this.languageCode,
  });

  /// Convenient constructor from EsnapOccasionTranslation
  factory OccasionTranslationSchema.fromOccasionTranslationSchema(
    EsnapOccasionTranslation occasion,
  ) {
    return OccasionTranslationSchema(
      id: occasion.id,
      name: occasion.name,
      occasionId: occasion.occasionId,
      languageCode: occasion.languageCode,
    );
  }

  /// The unique id for this translation.
  @HiveField(0)
  String id;

  /// The resulted text from translating [EsnapOccasion.name] to the
  /// [languageCode] language.
  @HiveField(1)
  String name;

  /// The occasion id of the occasion this translation corresponds.
  @HiveField(2)
  String occasionId;

  /// The occasion language code.
  @HiveField(3)
  String languageCode;

  /// Convenient transformer.
  EsnapOccasionTranslation toEsnapOccasion() => EsnapOccasionTranslation(
        id: id,
        name: name,
        occasionId: occasionId,
        languageCode: languageCode,
      );
}
