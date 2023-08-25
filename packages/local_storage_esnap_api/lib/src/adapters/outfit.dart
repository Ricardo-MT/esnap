import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';
import 'package:local_storage_esnap_api/src/adapters/item.dart';

import 'package:local_storage_esnap_api/src/esnap_boxes.dart';

part 'outfit.g.dart';

/// A Hive class mimmicking the Outfit class
@HiveType(typeId: 6)
class OutfitSchema extends HiveObject {
  /// Basic constructor
  OutfitSchema({
    required this.id,
    required this.top,
    required this.bottom,
    required this.shoes,
  });

  /// The unique id for the item
  @HiveField(0)
  String id;

  /// The item´s color
  @HiveField(1)
  HiveList<ItemSchema> top;

  /// The item´s classification
  @HiveField(2)
  HiveList<ItemSchema> bottom;

  /// A list of the item's occasions.
  @HiveField(3)
  HiveList<ItemSchema> shoes;

  /// Creates an instance of an OutfitSchema from an Outfit
  static Future<OutfitSchema> fromOutfit(Outfit outfit) async {
    /// Field top
    final itemBox = Hive.box<ItemSchema>(EsnapBoxes.item);
    final topList = HiveList<ItemSchema>(
      itemBox,
    );
    if (outfit.top != null) {
      final oneItem = itemBox.get(outfit.top!.id);
      topList.add(oneItem!);
    }

    /// Field bottom
    final bottomList = HiveList<ItemSchema>(
      itemBox,
    );
    if (outfit.bottom != null) {
      final oneItem = itemBox.get(outfit.bottom!.id);
      bottomList.add(oneItem!);
    }

    /// Field shows
    final shoesList = HiveList<ItemSchema>(
      itemBox,
    );
    if (outfit.shoes != null) {
      final oneItem = itemBox.get(outfit.shoes!.id);
      shoesList.add(oneItem!);
    }

    return OutfitSchema(
      id: outfit.id,
      top: topList,
      bottom: bottomList,
      shoes: shoesList,
    );
  }

  /// Returns an outfit based on this instance values
  Outfit toOutfit() => Outfit(
        id: id,
        top: _getFromItemList(top),
        bottom: _getFromItemList(bottom),
        shoes: _getFromItemList(shoes),
      );
}

/// Gets the list from the hive object and returns the first object
Item? _getFromItemList(
  HiveList<HiveObjectMixin> items,
) {
  final list = items.map((e) => (e as ItemSchema).toItem()).toList();
  if (list.isEmpty) return null;
  return list[0];
}
