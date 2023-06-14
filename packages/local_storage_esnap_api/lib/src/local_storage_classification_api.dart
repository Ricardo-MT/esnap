import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/classification.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:rxdart/subjects.dart';

/// {@template local_storage_classification_api}
/// A Flutter implementation of the ClassificationApi that uses local storage
/// {@endtemplate}
class LocalStorageClassificationApi extends ClassificationApi {
  /// {@macro local_storage_classification_api}
  LocalStorageClassificationApi(this.box) {
    final classificationsRes = box.values;
    _classificationStreamController
        .add(classificationsRes.map((c) => c.toEsnapClassification()).toList());
  }

  final _classificationStreamController =
      BehaviorSubject<List<EsnapClassification>>.seeded(const []);

  /// The box for handling classifications
  final Box<ClassificationSchema> box;

  /// This method opens the box, runs the initial migrations and
  /// returns an instance of the LocalStorageClassificationApi class.
  static Future<LocalStorageClassificationApi> initializer() async {
    Hive.registerAdapter(ClassificationSchemaAdapter());
    final box = await Hive.openBox<ClassificationSchema>(
      EsnapBoxes.classification,
    );
    await _initMigrations(box);
    return LocalStorageClassificationApi(box);
  }

  @override
  Stream<List<EsnapClassification>> getClassifications() =>
      _classificationStreamController.asBroadcastStream();

  @override
  Future<void> saveClassification(EsnapClassification classification) {
    final classifications = [..._classificationStreamController.value];
    final classificationIndex =
        classifications.indexWhere((t) => t.id == classification.id);
    if (classificationIndex >= 0) {
      classifications[classificationIndex] = classification;
    } else {
      classifications.add(classification);
    }
    _classificationStreamController.add(classifications);

    return Hive.box<ClassificationSchema>(EsnapBoxes.classification).put(
      classification.id,
      ClassificationSchema.fromClassificationSchema(classification),
    );
  }

  @override
  Future<void> deleteClassification(String id) async {
    final classifications = [..._classificationStreamController.value];
    final classificationIndex = classifications.indexWhere((t) => t.id == id);
    if (classificationIndex == -1) {
      throw ClassificationNotFoundException();
    } else {
      classifications.removeAt(classificationIndex);
      _classificationStreamController.add(classifications);
      // return _setValue(kTodosCollectionKey, json.encode(classifications));
    }
  }

  static Future<void> _initMigrations(Box<ClassificationSchema> box) async {
    const migratedKey = 'migratedClassification';
    final migratedBox = Hive.box<bool>(EsnapBoxes.migrated);
    final hasData = migratedBox.get(migratedKey, defaultValue: false);
    if (!(hasData ?? false)) {
      await box.clear();
      final classifications = _baseClassification.map(
        (c) => ClassificationSchema.fromClassificationSchema(
          EsnapClassification(name: c),
        ),
      );
      for (final element in classifications) {
        await box.put(element.id, element);
      }
      await migratedBox.put(migratedKey, true);
    }
  }
}

const _baseClassification = [
  'jumper',
  'blouse',
  'shirt',
  'skirt',
  'short',
  't-shirt',
  'cap',
  'glasses',
];
