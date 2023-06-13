import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/color.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:rxdart/subjects.dart';

/// {@template local_storage_color_api}
/// A Flutter implementation of the ColorApi that uses local storage
/// {@endtemplate}
class LocalStorageColorApi extends ColorApi {
  /// {@macro local_storage_color_api}
  LocalStorageColorApi() {
    _init();
  }

  final _colorStreamController =
      BehaviorSubject<List<EsnapColor>>.seeded(const []);

  Future<void> _init() async {
    await _initHive();
    final box = await Hive.openBox<ColorSchema>(EsnapBoxes.color);
    await _initMigrations(box);
    final colorsRes = box.values;
    _colorStreamController.add(colorsRes.map((c) => c.toEsnapColor()).toList());
  }

  Future<void> _initHive() async {
    Hive.registerAdapter(ColorSchemaAdapter());
    await Hive.initFlutter();
  }

  @override
  Stream<List<EsnapColor>> getColors() =>
      _colorStreamController.asBroadcastStream();

  @override
  Future<void> saveColor(EsnapColor color) {
    final colors = [..._colorStreamController.value];
    final colorIndex = colors.indexWhere((t) => t.id == color.id);
    if (colorIndex >= 0) {
      colors[colorIndex] = color;
    } else {
      colors.add(color);
    }
    _colorStreamController.add(colors);

    return Hive.box<ColorSchema>(EsnapBoxes.color)
        .put(color.id, ColorSchema.fromEsnapColor(color));
  }

  @override
  Future<void> deleteColor(String id) async {
    final colors = [..._colorStreamController.value];
    final colorIndex = colors.indexWhere((t) => t.id == id);
    if (colorIndex == -1) {
      throw ColorNotFoundException();
    } else {
      colors.removeAt(colorIndex);
      _colorStreamController.add(colors);
      // return _setValue(kTodosCollectionKey, json.encode(colors));
    }
  }

  Future<void> _initMigrations(Box<ColorSchema> box) async {
    const migratedKey = 'migratedColor';
    final migratedBox = await Hive.openBox<bool>(EsnapBoxes.migrated);
    final hasData = migratedBox.get(migratedKey, defaultValue: false);
    if (!(hasData ?? false)) {
      await box.clear();
      final colors = _baseColors
          .map((c) => ColorSchema.fromEsnapColor(EsnapColor(name: c)));
      for (final element in colors) {
        await box.put(element.id, element);
      }
      await migratedBox.put(migratedKey, true);
      await migratedBox.close();
    }
  }
}

const _baseColors = [
  'red',
  'blue',
  'green',
  'yellow',
  'white',
  'black',
  'silver',
  'gold',
];
