import 'package:hive/hive.dart';
import 'package:local_storage_esnap_api/src/adapters/classification.dart';
import 'package:local_storage_esnap_api/src/adapters/occasion.dart';

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
    required this.imagePath,
    required this.favorite,
  });

  /// The unique id for the item
  @HiveField(0)
  String id;

  /// The item´s color
  @HiveField(1)
  HiveList color;

  /// The item´s classification
  @HiveField(2)
  HiveList<ClassificationSchema> classification;

  /// A list of the item's occasions.
  @HiveField(3)
  HiveList<OccasionSchema> occasions;

  /// A list of the item's occasions.
  @HiveField(4)
  String imagePath;

  /// A list of the item's occasions.
  @HiveField(5)
  bool favorite;
}
