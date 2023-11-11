import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/classification_type.dart';
import 'package:local_storage_esnap_api/src/adapters/classification_type_translation.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:local_storage_esnap_api/src/seed_data/classification_type_seed.dart';
import 'package:rxdart/subjects.dart';

/// {@template local_storage_classification_api}
/// A Flutter implementation of the ClassificationApi that uses local storage
/// {@endtemplate}
class LocalStorageClassificationTypeApi extends ClassificationTypeApi {
  /// {@macro local_storage_classification_api}
  LocalStorageClassificationTypeApi(this.box, this.translationBox) {
    final classificationsRes = box.values;
    _classificationStreamController.add(
      classificationsRes.map((c) => c.toEsnapClassificationType()).toList(),
    );
  }

  final _classificationStreamController =
      BehaviorSubject<List<EsnapClassificationType>>.seeded(const []);

  /// The box for handling classifications
  final Box<ClassificationTypeSchema> box;

  /// The box for handling classification types translations
  final Box<ClassificationTypeTranslationSchema> translationBox;

  /// This method opens the box, runs the initial migrations and
  /// returns an instance of the LocalStorageClassificationTypeApi class.
  static Future<LocalStorageClassificationTypeApi> initializer() async {
    Hive
      ..registerAdapter(ClassificationTypeSchemaAdapter())
      ..registerAdapter(ClassificationTypeTranslationSchemaAdapter());
    final box = await Hive.openBox<ClassificationTypeSchema>(
      EsnapBoxes.classificationType,
    );
    final translationBox =
        await Hive.openBox<ClassificationTypeTranslationSchema>(
      EsnapBoxes.classificationTypeTranslation,
    );
    await _initMigrations(box, translationBox);
    return LocalStorageClassificationTypeApi(box, translationBox);
  }

  @override
  Stream<List<EsnapClassificationType>> getClassificationTypes() =>
      _classificationStreamController.asBroadcastStream();

  static Future<void> _initMigrations(
    Box<ClassificationTypeSchema> box,
    Box<ClassificationTypeTranslationSchema> translationBox,
  ) async {
    const migratedKey = 'migratedClassificationType';
    final migratedBox = Hive.box<bool>(EsnapBoxes.migrated);
    final hasData = migratedBox.get(migratedKey, defaultValue: false) ?? false;
    if (!hasData) {
      await Future.wait([
        box.clear(),
        translationBox.clear(),
      ]);
      final translations = <dynamic, ClassificationTypeTranslationSchema>{};
      final classifications = classificationTypeSeeds.map(
        (c) {
          final schema = ClassificationTypeSchema.fromEsnapClassificationType(
            EsnapClassificationType(name: c.name, id: c.name),
          );
          final translationEn = ClassificationTypeTranslationSchema
              .fromClassificationTypeTranslationSchema(
            EsnapClassificationTypeTranslation(
              name: c.en,
              classificationTypeId: schema.id,
              languageCode: 'en',
            ),
          );
          final translationEs = ClassificationTypeTranslationSchema
              .fromClassificationTypeTranslationSchema(
            EsnapClassificationTypeTranslation(
              name: c.es,
              classificationTypeId: schema.id,
              languageCode: 'es',
            ),
          );
          translations[translationEn.id] = translationEn;
          translations[translationEs.id] = translationEs;
          return schema;
        },
      );
      for (final element in classifications) {
        await box.put(element.id, element);
      }
      await translationBox.putAll(translations);
      await migratedBox.put(migratedKey, true);
    }
  }

  @override
  List<EsnapClassificationTypeTranslation> getStaticTranslations() {
    final translations = translationBox.values;
    return translations.map((t) => t.toEsnapClassification()).toList();
  }
}
