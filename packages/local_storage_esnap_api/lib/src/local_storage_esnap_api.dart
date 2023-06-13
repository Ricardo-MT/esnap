import 'dart:io';

import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/classification.dart';
import 'package:local_storage_esnap_api/src/adapters/color.dart';
import 'package:local_storage_esnap_api/src/adapters/item.dart';
import 'package:local_storage_esnap_api/src/adapters/occasion.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:rxdart/subjects.dart';

/// {@template local_storage_esnap_api}
/// A Flutter implementation of the EsnapApi that uses local storage
/// {@endtemplate}
class LocalStorageEsnapApi extends EsnapApi {
  /// {@macro local_storage_esnap_api}
  LocalStorageEsnapApi() {
    _init();
  }

  final _itemStreamController = BehaviorSubject<List<Item>>.seeded(const []);

  Future<void> _init() async {
    await _initHive();
    final box = await Hive.openBox<ItemSchema>(EsnapBoxes.item);
    final itemsRes = box.values;
    _itemStreamController.add(itemsRes.map(toItem).toList());
  }

  Future<void> _initHive() async {
    Hive.registerAdapter(ItemSchemaAdapter());
    await Hive.initFlutter();
  }

  @override
  Stream<List<Item>> getItems() => _itemStreamController.asBroadcastStream();

  @override
  Future<void> saveItem(Item item) async {
    final items = [..._itemStreamController.value];
    final itemIndex = items.indexWhere((t) => t.id == item.id);
    if (itemIndex >= 0) {
      items[itemIndex] = item;
    } else {
      items.add(item);
    }
    _itemStreamController.add(items);
    final item0 = await fromItem(item);
    return Hive.box<ItemSchema>(EsnapBoxes.item).put(item.id, item0);
  }

  @override
  Future<void> deleteItem(String id) async {
    final items = [..._itemStreamController.value];
    final itemIndex = items.indexWhere((t) => t.id == id);
    if (itemIndex == -1) {
      throw ItemNotFoundException();
    } else {
      items.removeAt(itemIndex);
      _itemStreamController.add(items);
      // return _setValue(kTodosCollectionKey, json.encode(items));
    }
  }
}

/// Creates an instance of an ItemSchema from an Item
Future<ItemSchema> fromItem(Item item) async {
  /// Field color
  final colorBox = await Hive.openBox<ColorSchema>(EsnapBoxes.color);
  final oneColor = ColorSchema.fromEsnapColor(item.color!);
  final colorList = HiveList(colorBox, objects: [oneColor]);

  /// Field classification
  final classificationBox =
      await Hive.openBox<ClassificationSchema>(EsnapBoxes.classification);
  final oneClassification =
      ClassificationSchema.fromClassificationSchema(item.classification!);
  final classificationList =
      HiveList(classificationBox, objects: [oneClassification]);

  /// Field occasions
  final occasionBox =
      await Hive.openBox<ColorSchema>(EsnapBoxes.classification);
  final occasions =
      item.occasions.map(OccasionSchema.fromEsnapOccasion).toList();
  final occasionList = HiveList(occasionBox, objects: occasions);

  return ItemSchema(
    id: item.id,
    color: colorList,
    classification: classificationList,
    occasions: occasionList,
  );
}

/// Returns an item based on this instance values
Item toItem(ItemSchema itemSchema) => Item(
      id: itemSchema.id,
      color: itemSchema.color
          .map((e) => (e as ColorSchema).toEsnapColor())
          .toList()[0],
      classification: itemSchema.classification
          .map((e) => (e as ClassificationSchema).toEsnapClassification())
          .toList()[0],
      occasions: itemSchema.occasions
          .map((e) => (e as OccasionSchema).toEsnapOccasion())
          .toList(),
      image: File(''),
    );
