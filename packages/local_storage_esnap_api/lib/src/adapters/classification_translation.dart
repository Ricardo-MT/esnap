import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';

part 'classification_translation.g.dart';

/// A Hive class mimmicking the EsnapClassificationTranslation class
@HiveType(typeId: 7)
class ClassificationTranslationSchema extends HiveObject {
  /// Basic constructor
  ClassificationTranslationSchema({
    required this.id,
    required this.name,
    required this.classificationId,
    required this.languageCode,
  });

  /// Convenient constructor from EsnapClassificationTranslation
  factory ClassificationTranslationSchema.fromClassificationTranslationSchema(
    EsnapClassificationTranslation classification,
  ) {
    return ClassificationTranslationSchema(
      id: classification.id,
      name: classification.name,
      classificationId: classification.classificationId,
      languageCode: classification.languageCode,
    );
  }

  /// The unique id for this translation.
  @HiveField(0)
  String id;

  /// The resulted text from translating [EsnapClassification.name] to the
  /// [languageCode] language.
  @HiveField(1)
  String name;

  /// The classification id of the classification this translation corresponds.
  @HiveField(2)
  String classificationId;

  /// The classification language code.
  @HiveField(3)
  String languageCode;

  /// Convenient transformer.
  EsnapClassificationTranslation toEsnapClassification() =>
      EsnapClassificationTranslation(
        id: id,
        name: name,
        classificationId: classificationId,
        languageCode: languageCode,
      );
}
