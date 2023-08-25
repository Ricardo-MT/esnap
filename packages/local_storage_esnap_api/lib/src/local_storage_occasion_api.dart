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
  LocalStorageOccasionApi(this.box) {
    final occasionsRes = box.values;
    _occasionStreamController
        .add(occasionsRes.map((o) => o.toEsnapOccasion()).toList());
  }

  final _occasionStreamController =
      BehaviorSubject<List<EsnapOccasion>>.seeded(const []);

  /// The box for handling colors
  final Box<OccasionSchema> box;

  /// This method opens the box, runs the initial migrations and
  /// returns an instance of the LocalStorageOccasionApi class.
  static Future<LocalStorageOccasionApi> initializer() async {
    Hive.registerAdapter(OccasionSchemaAdapter());
    final box = await Hive.openBox<OccasionSchema>(EsnapBoxes.occasion);
    await _initMigrations(box);
    return LocalStorageOccasionApi(box);
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
        .put(occasion.id, OccasionSchema.fromEsnapOccasion(occasion));
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

  static Future<void> _initMigrations(Box<OccasionSchema> box) async {
    const migratedKey = 'migratedOccasion';
    final migratedBox = Hive.box<bool>(EsnapBoxes.migrated);
    final hasData = migratedBox.get(migratedKey, defaultValue: false);
    if (!(hasData ?? false)) {
      await box.clear();
      final occasions = _baseOccasions.map(
        (c) => OccasionSchema.fromEsnapOccasion(
          EsnapOccasion(
            name: c,
            id: c,
          ),
        ),
      );
      for (final element in occasions) {
        await box.put(element.id, element);
      }
      await migratedBox.put(migratedKey, true);
    }
  }
}

const _baseOccasions = [
  'Afternoon tea',
  'Art gallery opening',
  'Athletic',
  'Beachwear',
  'Black tie',
  'Business casual',
  'Business formal',
  'Business presentation',
  'Charity gala',
  'Clubbing',
  'Concert',
  'Costume or cosplay',
  'Cruise',
  'Date night',
  'Festival',
  'Graduation',
  'Workout',
  'Job interview',
  'Lounge or sleepwear',
  'Maternity',
  'Matinee and theater',
  'Outdoor and adventure',
  'Outdoor wedding',
  'Party wear',
  'Picnic and outdoor gathering',
  'Professional conference',
  'Prom or formal dance',
  'Religious or cultural ceremony',
  'Resort casual',
  'Resort wear',
  'Ski or snowboarding',
  'Sports team jersey or fan gear',
  'Vacation or travel',
  'Wedding guest',
  'White tie',
  'Yoga wear',
];
