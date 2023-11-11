import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/color.dart';
import 'package:local_storage_esnap_api/src/adapters/color_translation.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:local_storage_esnap_api/src/seed_data/color_seed.dart';
import 'package:rxdart/subjects.dart';

/// {@template local_storage_color_api}
/// A Flutter implementation of the ColorApi that uses local storage
/// {@endtemplate}
class LocalStorageColorApi extends ColorApi {
  /// {@macro local_storage_color_api}
  LocalStorageColorApi(this.box, this.translationBox) {
    final colorsRes = box.values;
    _colorStreamController.add(colorsRes.map((c) => c.toEsnapColor()).toList());
  }

  final _colorStreamController =
      BehaviorSubject<List<EsnapColor>>.seeded(const []);

  /// The box for handling colors
  final Box<ColorSchema> box;

  /// The box for handling color translations
  final Box<ColorTranslationSchema> translationBox;

  /// This method opens the box, runs the initial migrations and
  /// returns an instance of the LocalStorageColorApi class.
  static Future<LocalStorageColorApi> initializer() async {
    Hive
      ..registerAdapter(ColorSchemaAdapter())
      ..registerAdapter(ColorTranslationSchemaAdapter());
    final box = await Hive.openBox<ColorSchema>(EsnapBoxes.color);
    final translationBox =
        await Hive.openBox<ColorTranslationSchema>(EsnapBoxes.colorTranslation);
    await _initMigrations(box, translationBox);
    return LocalStorageColorApi(box, translationBox);
  }

  @override
  Stream<List<EsnapColor>> getColors() =>
      _colorStreamController.asBroadcastStream();

  static Future<void> _initMigrations(
    Box<ColorSchema> box,
    Box<ColorTranslationSchema> translationBox,
  ) async {
    const migratedKey = 'migratedColor';
    final migratedBox = Hive.box<bool>(EsnapBoxes.migrated);
    final hasData = migratedBox.get(migratedKey, defaultValue: false);
    if (!(hasData ?? false)) {
      await Future.wait([
        box.clear(),
        translationBox.clear(),
      ]);
      final translations = <dynamic, ColorTranslationSchema>{};
      final colors = colorSeeds.map(
        (color) {
          final schema = ColorSchema.fromEsnapColor(
            EsnapColor(
              name: color.name,
              id: color.name,
              hexColor: color.hex,
            ),
          );
          final translationEn =
              ColorTranslationSchema.fromEsnapColorTranslation(
            EsnapColorTranslation(
              colorId: schema.id,
              languageCode: 'en',
              name: color.en,
            ),
          );
          final translationEs =
              ColorTranslationSchema.fromEsnapColorTranslation(
            EsnapColorTranslation(
              colorId: schema.id,
              languageCode: 'es',
              name: color.es,
            ),
          );
          translations[translationEn.id] = translationEn;
          translations[translationEs.id] = translationEs;
          return schema;
        },
      );
      for (final element in colors) {
        await box.put(element.id, element);
      }
      await translationBox.putAll(translations);
      await migratedBox.put(migratedKey, true);
    }
  }

  @override
  List<EsnapColorTranslation> getStaticTranslations() {
    final translations = translationBox.values;
    return translations.map((t) => t.toEsnapColor()).toList();
  }
}
