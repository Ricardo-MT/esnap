import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/classification.dart';
import 'package:local_storage_esnap_api/src/adapters/classification_type.dart';
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
  static Future<LocalStorageClassificationApi> initializer(
    List<ClassificationTypeSchema> types,
  ) async {
    Hive.registerAdapter(ClassificationSchemaAdapter());
    final box = await Hive.openBox<ClassificationSchema>(
      EsnapBoxes.classification,
    );
    await _initMigrations(box, types);
    return LocalStorageClassificationApi(box);
  }

  /// The list of base classifications
  List<String> get baseClassification =>
      _baseClassification.map((e) => e['name']!).toList();

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

  static Future<void> _initMigrations(
    Box<ClassificationSchema> box,
    List<ClassificationTypeSchema> types,
  ) async {
    const migratedKey = 'migratedClassification';
    final migratedBox = Hive.box<bool>(EsnapBoxes.migrated);
    final hasData = migratedBox.get(migratedKey, defaultValue: false);
    if (!(hasData ?? false)) {
      await box.clear();
      final classifications = _baseClassification.map(
        (c) => ClassificationSchema.fromClassificationSchema(
          EsnapClassification(
            name: c['name']!,
            id: c['name'],
            classificationType: types
                .firstWhere(
                  (t) => t.name == c['type']!,
                  orElse: () =>
                      types.firstWhere((element) => element.name == 'Other'),
                )
                .toEsnapClassificationType(),
          ),
        ),
      );
      for (final element in classifications) {
        await box.put(element.id, element);
      }
      await migratedBox.put(migratedKey, true);
    }
  }

  @override

  /// The list of classifications
  List<EsnapClassification> getStaticClassifications() =>
      box.values.map((e) => e.toEsnapClassification()).toList();
}

const _baseClassification = [
  {'name': 'Accessory', 'type': 'Top'},
  {'name': 'Activewear', 'type': 'Top'},
  {'name': 'Bag', 'type': 'Other'},
  {'name': 'Blouse', 'type': 'Top'},
  {'name': 'Boots', 'type': 'Shoes'},
  {'name': 'Bottom', 'type': 'Bottom'},
  {'name': 'Dress', 'type': 'Top'},
  {'name': 'Gloves', 'type': 'Other'},
  {'name': 'Headwear', 'type': 'Top'},
  {'name': 'Heels', 'type': 'Shoes'},
  {'name': 'Jacket', 'type': 'Top'},
  {'name': 'Jewelry', 'type': 'Top'},
  {'name': 'Leggings', 'type': 'Bottom'},
  {'name': 'Lingerie', 'type': 'Bottom'},
  {'name': 'Outerwear', 'type': 'Top'},
  {'name': 'Sandals', 'type': 'Shoes'},
  {'name': 'Shirt', 'type': 'Shirt'},
  {'name': 'Shoes', 'type': 'Shoes'},
  {'name': 'Skirt', 'type': 'Bottom'},
  {'name': 'Sleepwear', 'type': 'Top'},
  {'name': 'Sneakers', 'type': 'Shoes'},
  {'name': 'Suiting', 'type': 'Top'},
  {'name': 'Sunglasses', 'type': 'Top'},
  {'name': 'Sweater', 'type': 'Top'},
  {'name': 'Swimwear', 'type': 'Top'},
  {'name': 'Top', 'type': 'Top'},
  {'name': 'Tights', 'type': 'Bottom'},
  {'name': 'Underwear', 'type': 'Bottom'},
  {'name': 'Vest', 'type': 'Top'},
  {'name': 'Waistcoat', 'type': 'Bottom'},
  {'name': 'Other', 'type': 'Top'},
];
