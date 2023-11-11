import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/occasion.dart';
import 'package:local_storage_esnap_api/src/adapters/occasion_translation.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:local_storage_esnap_api/src/seed_data/occasion_seed.dart';
import 'package:rxdart/subjects.dart';

/// {@template local_storage_occasion_api}
/// A Flutter implementation of the OccasionApi that uses local storage
/// {@endtemplate}
class LocalStorageOccasionApi extends OccasionApi {
  /// {@macro local_storage_occasion_api}
  LocalStorageOccasionApi(this.box, this.translationBox) {
    final occasionsRes = box.values;
    _occasionStreamController
        .add(occasionsRes.map((o) => o.toEsnapOccasion()).toList());
  }

  final _occasionStreamController =
      BehaviorSubject<List<EsnapOccasion>>.seeded(const []);

  /// The box for handling colors
  final Box<OccasionSchema> box;

  /// The box for handling color translations
  final Box<OccasionTranslationSchema> translationBox;

  /// This method opens the box, runs the initial migrations and
  /// returns an instance of the LocalStorageOccasionApi class.
  static Future<LocalStorageOccasionApi> initializer() async {
    Hive
      ..registerAdapter(OccasionSchemaAdapter())
      ..registerAdapter(OccasionTranslationSchemaAdapter());
    final box = await Hive.openBox<OccasionSchema>(EsnapBoxes.occasion);
    final translationBox = await Hive.openBox<OccasionTranslationSchema>(
      EsnapBoxes.occasionTranslation,
    );
    await _initMigrations(box, translationBox);
    return LocalStorageOccasionApi(box, translationBox);
  }

  @override
  Stream<List<EsnapOccasion>> getOccasions() =>
      _occasionStreamController.asBroadcastStream();

  static Future<void> _initMigrations(
    Box<OccasionSchema> box,
    Box<OccasionTranslationSchema> translationBox,
  ) async {
    const migratedKey = 'migratedOccasion';
    final migratedBox = Hive.box<bool>(EsnapBoxes.migrated);
    final hasData = migratedBox.get(migratedKey, defaultValue: false);
    if (!(hasData ?? false)) {
      await Future.wait([
        box.clear(),
        translationBox.clear(),
      ]);
      final translations = <dynamic, OccasionTranslationSchema>{};
      final occasions = occasionSeeds.map(
        (c) {
          final schema = OccasionSchema.fromEsnapOccasion(
            EsnapOccasion(
              name: c.name,
              id: c.name,
            ),
          );
          final translationEn =
              OccasionTranslationSchema.fromOccasionTranslationSchema(
            EsnapOccasionTranslation(
              languageCode: 'en',
              name: c.en,
              occasionId: schema.id,
            ),
          );
          final translationEs =
              OccasionTranslationSchema.fromOccasionTranslationSchema(
            EsnapOccasionTranslation(
              languageCode: 'es',
              name: c.es,
              occasionId: schema.id,
            ),
          );
          translations[translationEn.id] = translationEn;
          translations[translationEs.id] = translationEs;
          return schema;
        },
      );
      for (final element in occasions) {
        await box.put(element.id, element);
      }
      await translationBox.putAll(translations);
      await migratedBox.put(migratedKey, true);
    }
  }

  @override
  List<EsnapOccasionTranslation> getStaticTranslations() {
    final translations =
        translationBox.values.map((t) => t.toEsnapOccasion()).toList();
    return translations;
  }
}
