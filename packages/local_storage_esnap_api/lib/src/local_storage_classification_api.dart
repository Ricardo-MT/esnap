import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/classification.dart';
import 'package:local_storage_esnap_api/src/adapters/classification_translation.dart';
import 'package:local_storage_esnap_api/src/adapters/classification_type.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:local_storage_esnap_api/src/seed_data/classification_seed.dart';
import 'package:rxdart/subjects.dart';

/// {@template local_storage_classification_api}
/// A Flutter implementation of the ClassificationApi that uses local storage
/// {@endtemplate}
class LocalStorageClassificationApi extends ClassificationApi {
  /// {@macro local_storage_classification_api}
  LocalStorageClassificationApi(this.box, this.translationBox) {
    final classificationsRes = box.values;
    _classificationStreamController
        .add(classificationsRes.map((c) => c.toEsnapClassification()).toList());
  }

  final _classificationStreamController =
      BehaviorSubject<List<EsnapClassification>>.seeded(const []);

  /// The box for handling classifications
  final Box<ClassificationSchema> box;

  /// The box for handling classification translations
  final Box<ClassificationTranslationSchema> translationBox;

  /// This method opens the box, runs the initial migrations and
  /// returns an instance of the LocalStorageClassificationApi class.
  static Future<LocalStorageClassificationApi> initializer(
    List<ClassificationTypeSchema> types,
  ) async {
    Hive
      ..registerAdapter(ClassificationSchemaAdapter())
      ..registerAdapter(ClassificationTranslationSchemaAdapter());
    final box = await Hive.openBox<ClassificationSchema>(
      EsnapBoxes.classification,
    );
    final translationBox = await Hive.openBox<ClassificationTranslationSchema>(
      EsnapBoxes.classificationTranslation,
    );
    await _initMigrations(box, translationBox, types);
    return LocalStorageClassificationApi(box, translationBox);
  }

  @override
  Stream<List<EsnapClassification>> getClassifications() =>
      _classificationStreamController.asBroadcastStream();

  static Future<void> _initMigrations(
    Box<ClassificationSchema> box,
    Box<ClassificationTranslationSchema> translationBox,
    List<ClassificationTypeSchema> types,
  ) async {
    const migratedKey = 'migratedClassification';
    final migratedBox = Hive.box<bool>(EsnapBoxes.migrated);
    final hasData = migratedBox.get(migratedKey, defaultValue: false);
    if (!(hasData ?? false)) {
      await Future.wait([
        box.clear(),
        translationBox.clear(),
      ]);
      final translations = <dynamic, ClassificationTranslationSchema>{};
      final classifications = classificationSeeds.map(
        (c) {
          final schema = ClassificationSchema.fromClassificationSchema(
            EsnapClassification(
              name: c.name,
              id: c.name,
              classificationType: types
                  .firstWhere(
                    (t) => t.name == c.classificationType.name,
                    orElse: () =>
                        types.firstWhere((element) => element.name == 'Other'),
                  )
                  .toEsnapClassificationType(),
            ),
          );
          final translationEn = ClassificationTranslationSchema
              .fromClassificationTranslationSchema(
            EsnapClassificationTranslation(
              name: c.en,
              classificationId: schema.id,
              languageCode: 'en',
            ),
          );
          final translationEs = ClassificationTranslationSchema
              .fromClassificationTranslationSchema(
            EsnapClassificationTranslation(
              name: c.es,
              classificationId: schema.id,
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

  /// The list of classifications
  List<EsnapClassification> getStaticClassifications() =>
      box.values.map((e) => e.toEsnapClassification()).toList();

  @override
  List<EsnapClassificationTranslation> getStaticTranslations() {
    final translations = translationBox.values;
    return translations
        .map((e) => e.toEsnapClassification())
        .toList(growable: false);
  }
}
