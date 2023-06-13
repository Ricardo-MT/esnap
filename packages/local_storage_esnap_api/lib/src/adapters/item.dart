import 'package:hive/hive.dart';

part 'item.g.dart';

/// A Hive class mimmicking the Item class
@HiveType(typeId: 1)
class ItemSchema extends HiveObject {
  /// Basic constructor
  ItemSchema({
    required this.id,
    required this.classification,
    required this.occasions,
    required this.color,
  });

  /// The unique id for the item
  @HiveField(0)
  String id;

  /// The item´s color
  @HiveField(1)
  HiveList color;

  /// The item´s classification
  @HiveField(2)
  HiveList classification;

  /// A list of the item's occasions.
  @HiveField(3)
  HiveList occasions;
}
