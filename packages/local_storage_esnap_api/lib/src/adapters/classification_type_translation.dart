import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';

part 'classification_type_translation.g.dart';

/// A Hive class mimmicking the EsnapClassificationTranslation class
@HiveType(typeId: 8)
class ClassificationTypeTranslationSchema extends HiveObject {
  /// Basic constructor
  ClassificationTypeTranslationSchema({
    required this.id,
    required this.name,
    required this.classificationTypeId,
    required this.languageCode,
  });

  /// Convenient constructor from EsnapClassificationTranslation
  factory ClassificationTypeTranslationSchema.fromClassificationTypeTranslationSchema(
    EsnapClassificationTypeTranslation classification,
  ) {
    return ClassificationTypeTranslationSchema(
      id: classification.id,
      name: classification.name,
      classificationTypeId: classification.classificationTypeId,
      languageCode: classification.languageCode,
    );
  }

  /// The unique id for this translation.
  @HiveField(0)
  String id;

  /// The resulted text from translating [EsnapClassificationType.name] to the
  /// [languageCode] language.
  @HiveField(1)
  String name;

  /// The classification id of the classification this translation corresponds.
  @HiveField(2)
  String classificationTypeId;

  /// The classification language code.
  @HiveField(3)
  String languageCode;

  /// Convenient transformer.
  EsnapClassificationTypeTranslation toEsnapClassification() =>
      EsnapClassificationTypeTranslation(
        id: id,
        name: name,
        classificationTypeId: classificationTypeId,
        languageCode: languageCode,
      );
}
