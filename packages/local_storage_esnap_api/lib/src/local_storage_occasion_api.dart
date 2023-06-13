import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/occasion.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:rxdart/subjects.dart';

/// {@template local_storage_occasion_api}
/// A Flutter implementation of the OccasionApi that uses local storage
/// {@endtemplate}
class LocalStorageOccasionApi extends OccasionApi {
  /// {@macro local_storage_occasion_api}
  LocalStorageOccasionApi() {
    _init();
  }

  final _occasionStreamController =
      BehaviorSubject<List<EsnapOccasion>>.seeded(const []);

  Future<void> _init() async {
    await _initHive();
    final box = await Hive.openBox<OccasionSchema>(EsnapBoxes.occasion);
    final occasionsRes = box.values;
    _occasionStreamController.add(occasionsRes.map(toOccasion).toList());
  }

  Future<void> _initHive() async {
    Hive.registerAdapter(OccasionSchemaAdapter());
    await Hive.initFlutter();
  }

  @override
  Stream<List<EsnapOccasion>> getOccasions() =>
      _occasionStreamController.asBroadcastStream();

  @override
  Future<void> saveOccasion(EsnapOccasion occasion) {
    final occasions = [..._occasionStreamController.value];
    final occasionIndex = occasions.indexWhere((t) => t.id == occasion.id);
    if (occasionIndex >= 0) {
      occasions[occasionIndex] = occasion;
    } else {
      occasions.add(occasion);
    }
    _occasionStreamController.add(occasions);

    return Hive.box<OccasionSchema>(EsnapBoxes.occasion)
        .put(occasion.id, fromOccasion(occasion));
  }

  @override
  Future<void> deleteOccasion(String id) async {
    final occasions = [..._occasionStreamController.value];
    final occasionIndex = occasions.indexWhere((t) => t.id == id);
    if (occasionIndex == -1) {
      throw OccasionNotFoundException();
    } else {
      occasions.removeAt(occasionIndex);
      _occasionStreamController.add(occasions);
      // return _setValue(kTodosCollectionKey, json.encode(occasions));
    }
  }
}

/// Creates an instance from an EsnapOccasion
OccasionSchema fromOccasion(EsnapOccasion occasion) =>
    OccasionSchema(id: occasion.id, name: occasion.name);

/// Returns an occasion based on this instance values
EsnapOccasion toOccasion(OccasionSchema occasionSchema) => EsnapOccasion(
      id: occasionSchema.id,
      name: occasionSchema.name,
    );
