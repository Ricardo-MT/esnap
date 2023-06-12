import 'package:hive/hive.dart';

part 'item.g.dart';

/// A Hive class mimmicking the Item class
@HiveType(typeId: 1)
class ItemSchema {
  /// The unique id for the item
  @HiveField(0)
  late String id;

  /// The item´s color
  @HiveField(2)
  late String color;

  /// The item´s classification
  @HiveField(1)
  late String classification;

  /// A list of the item's occasions.
  @HiveField(3)
  late List<String> occasions;
}
