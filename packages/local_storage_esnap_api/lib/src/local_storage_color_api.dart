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
  LocalStorageColorApi(this.box) {
    final colorsRes = box.values;
    _colorStreamController.add(colorsRes.map((c) => c.toEsnapColor()).toList());
  }

  final _colorStreamController =
      BehaviorSubject<List<EsnapColor>>.seeded(const []);

  /// The box for handling colors
  final Box<ColorSchema> box;

  /// This method opens the box, runs the initial migrations and
  /// returns an instance of the LocalStorageColorApi class.
  static Future<LocalStorageColorApi> initializer() async {
    Hive.registerAdapter(ColorSchemaAdapter());
    final box = await Hive.openBox<ColorSchema>(EsnapBoxes.color);
    await _initMigrations(box);
    return LocalStorageColorApi(box);
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

  static Future<void> _initMigrations(Box<ColorSchema> box) async {
    const migratedKey = 'migratedColor';
    final migratedBox = Hive.box<bool>(EsnapBoxes.migrated);
    final hasData = migratedBox.get(migratedKey, defaultValue: false);
    if (!(hasData ?? false)) {
      await box.clear();
      final colors = List.generate(
        _baseColors.length,
        (index) => ColorSchema.fromEsnapColor(
          EsnapColor(
            name: _baseColors[index],
            hexColor: _baseHexColors[index],
          ),
        ),
      );
      for (final element in colors) {
        await box.put(element.id, element);
      }
      await migratedBox.put(migratedKey, true);
    }
  }
}

const _baseColors = [
  'Beige',
  'Black',
  'Blue',
  'Brown',
  'Coral',
  'Gold',
  'Gray',
  'Green',
  'Maroon',
  'Multicolor',
  'Navy',
  'Olive',
  'Orange',
  'Pink',
  'Purple',
  'Red',
  'Silver',
  'Teal',
  'Turquoise',
  'White',
  'Yellow',
];

const _baseHexColors = [
  0xFFF5F5DC,
  0xFF000000,
  0xFF2020DA,
  0xFFA52A2A,
  0xFFFF7F50,
  0xFFFFD700,
  0xFF808080,
  0xFF008000,
  0xFF800000,
  0xFF000000,
  0xFF000080,
  0xFF808000,
  0xFFFFA500,
  0xFFFFC0CB,
  0xFF800080,
  0xFFFF0000,
  0xFFC0C0C0,
  0xFF008080,
  0xFF40E0D0,
  0xFFFFFFFF,
  0xFFFFFF00,
];
