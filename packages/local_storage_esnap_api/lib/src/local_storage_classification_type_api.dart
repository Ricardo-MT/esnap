import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/classification_type.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:rxdart/subjects.dart';

/// {@template local_storage_classification_api}
/// A Flutter implementation of the ClassificationApi that uses local storage
/// {@endtemplate}
class LocalStorageClassificationTypeApi extends ClassificationTypeApi {
  /// {@macro local_storage_classification_api}
  LocalStorageClassificationTypeApi(this.box) {
    final classificationsRes = box.values;
    _classificationStreamController.add(
      classificationsRes.map((c) => c.toEsnapClassificationType()).toList(),
    );
  }

  final _classificationStreamController =
      BehaviorSubject<List<EsnapClassificationType>>.seeded(const []);

  /// The box for handling classifications
  final Box<ClassificationTypeSchema> box;

  /// This method opens the box, runs the initial migrations and
  /// returns an instance of the LocalStorageClassificationTypeApi class.
  static Future<LocalStorageClassificationTypeApi> initializer() async {
    Hive.registerAdapter(ClassificationTypeSchemaAdapter());
    final box = await Hive.openBox<ClassificationTypeSchema>(
      EsnapBoxes.classificationType,
    );
    await _initMigrations(box);
    return LocalStorageClassificationTypeApi(box);
  }

  @override
  List<String> get classificationTypes =>
      _baseClassificationTypes.map((e) => e).toList();

  @override
  Stream<List<EsnapClassificationType>> getClassificationTypes() =>
      _classificationStreamController.asBroadcastStream();

  @override
  Future<void> saveClassificationType(EsnapClassificationType classification) {
    final classifications = [..._classificationStreamController.value];
    final classificationIndex =
        classifications.indexWhere((t) => t.id == classification.id);
    if (classificationIndex >= 0) {
      classifications[classificationIndex] = classification;
    } else {
      classifications.add(classification);
    }
    _classificationStreamController.add(classifications);

    return Hive.box<ClassificationTypeSchema>(EsnapBoxes.classificationType)
        .put(
      classification.id,
      ClassificationTypeSchema.fromEsnapClassificationType(classification),
    );
  }

  static Future<void> _initMigrations(Box<ClassificationTypeSchema> box) async {
    const migratedKey = 'migratedClassificationType';
    final migratedBox = Hive.box<bool>(EsnapBoxes.migrated);
    final hasData = migratedBox.get(migratedKey, defaultValue: false) ?? false;
    if (!hasData) {
      await box.clear();
      final classifications = _baseClassificationTypes.map(
        (c) => ClassificationTypeSchema.fromEsnapClassificationType(
          EsnapClassificationType(name: c, id: c),
        ),
      );
      for (final element in classifications) {
        await box.put(element.id, element);
      }
      await migratedBox.put(migratedKey, true);
    }
  }
}

const _baseClassificationTypes = [
  'Top',
  'Bottom',
  'Shoes',
  'Other',
];
