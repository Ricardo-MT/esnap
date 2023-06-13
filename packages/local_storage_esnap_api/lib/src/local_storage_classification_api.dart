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
  LocalStorageClassificationApi() {
    _init();
  }

  final _classificationStreamController =
      BehaviorSubject<List<EsnapClassification>>.seeded(const []);

  Future<void> _init() async {
    await _initHive();
    final box =
        await Hive.openBox<ClassificationSchema>(EsnapBoxes.classification);
    final classificationsRes = box.values;
    _classificationStreamController
        .add(classificationsRes.map(toClassification).toList());
  }

  Future<void> _initHive() async {
    Hive.registerAdapter(ClassificationSchemaAdapter());
    await Hive.initFlutter();
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

    return Hive.box<ClassificationSchema>(EsnapBoxes.classification)
        .put(classification.id, fromClassification(classification));
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
}

/// Creates an instance from an EsnapClassification
ClassificationSchema fromClassification(EsnapClassification classification) =>
    ClassificationSchema(id: classification.id, name: classification.name);

/// Returns an classification based on this instance values
EsnapClassification toClassification(
  ClassificationSchema classificationSchema,
) =>
    EsnapClassification(
      id: classificationSchema.id,
      name: classificationSchema.name,
    );
