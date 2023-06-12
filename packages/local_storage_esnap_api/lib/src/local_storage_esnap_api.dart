import 'dart:io';

import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/item.dart';
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
  Future<void> saveItem(Item item) {
    final items = [..._itemStreamController.value];
    final itemIndex = items.indexWhere((t) => t.id == item.id);
    if (itemIndex >= 0) {
      items[itemIndex] = item;
    } else {
      items.add(item);
    }
    _itemStreamController.add(items);

    return Hive.box<ItemSchema>(EsnapBoxes.item).put(item.id, fromItem(item));
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

/// Creates an instance from an Item
ItemSchema fromItem(Item item) => ItemSchema()
  ..id = item.id
  ..color = item.color
  ..classification = item.classification
  ..occasions = item.occasions.toList();

/// Returns an item based on this instance values
Item toItem(ItemSchema itemSchema) => Item(
      id: itemSchema.id,
      color: itemSchema.color,
      classification: itemSchema.classification,
      occasions: itemSchema.occasions.toList(),
      image: File(''),
    );
