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
  LocalStorageEsnapApi(this.box) {
    final itemsRes = box.values;
    _itemStreamController.add(itemsRes.map(toItem).toList());
  }

  final _itemStreamController = BehaviorSubject<List<Item>>.seeded(const []);

  /// The box for handling colors
  final Box<ItemSchema> box;

  /// This method opens the box, runs the initial migrations and
  /// returns an instance of the LocalStorageColorApi class.
  static Future<LocalStorageEsnapApi> initializer() async {
    Hive.registerAdapter(ItemSchemaAdapter());
    final box = await Hive.openBox<ItemSchema>(EsnapBoxes.item);
    return LocalStorageEsnapApi(box);
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
    final item0 = fromItem(item);
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
ItemSchema fromItem(Item item) {
  /// Field color
  final colorBox = Hive.box<ColorSchema>(EsnapBoxes.color);
  final colorList = HiveList(
    colorBox,
  );
  if (item.color != null) {
    final oneColor = colorBox.get(item.color!.id);
    colorList.add(oneColor!);
  }

  /// Field classification
  final classificationBox =
      Hive.box<ClassificationSchema>(EsnapBoxes.classification);
  final classificationList = HiveList(
    classificationBox,
  );
  if (item.classification != null) {
    final oneClassification =
        ClassificationSchema.fromClassificationSchema(item.classification!);
    classificationList.add(oneClassification);
  }

  /// Field occasions
  final occasionBox = Hive.box<OccasionSchema>(EsnapBoxes.occasion);

  final occasionList = HiveList(
    occasionBox,
  );

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
      color: getFromColorList(itemSchema.color),
      classification: getFromClassificationList(itemSchema.classification),
      occasions: itemSchema.occasions
          .map((e) => (e as OccasionSchema).toEsnapOccasion())
          .toList(),
      image: File(''),
    );

/// Gets the list from the hive object and returns the first object
EsnapColor? getFromColorList(
  HiveList<HiveObjectMixin> colors,
) {
  final list = colors.map((e) => (e as ColorSchema).toEsnapColor()).toList();
  if (list.isEmpty) return null;
  return list[0];
}

/// Gets the list from the hive object and returns the first object
EsnapClassification? getFromClassificationList(
  HiveList<HiveObjectMixin> classifications,
) {
  final list = classifications
      .map((e) => (e as ClassificationSchema).toEsnapClassification())
      .toList();
  if (list.isEmpty) return null;
  return list[0];
}
