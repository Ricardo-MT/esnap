import 'dart:io';

import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';
import 'package:local_storage_esnap_api/src/adapters/classification.dart';
import 'package:local_storage_esnap_api/src/adapters/color.dart';
import 'package:local_storage_esnap_api/src/adapters/occasion.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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
  HiveList<ColorSchema> color;

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

  /// Convenient constructor from EsnapColor
  static Future<ItemSchema> fromItem(
    Item item,
  ) async {
    /// Field color
    final colorBox = Hive.box<ColorSchema>(EsnapBoxes.color);
    final colorList = HiveList<ColorSchema>(
      colorBox,
    );
    if (item.color != null) {
      final oneColor = colorBox.get(item.color!.id);
      colorList.add(oneColor!);
    }

    /// Field classification
    final classificationBox =
        Hive.box<ClassificationSchema>(EsnapBoxes.classification);
    final classificationList = HiveList<ClassificationSchema>(
      classificationBox,
    );
    if (item.classification != null) {
      final oneClassification = classificationBox.get(item.classification!.id);
      classificationList.add(oneClassification!);
    }

    /// Field occasions
    final occasionBox = Hive.box<OccasionSchema>(EsnapBoxes.occasion);
    final occasionList = HiveList<OccasionSchema>(
      occasionBox,
    )..addAll(
        item.occasions
            .map(
              (o) => occasionBox.get(o.id)!,
            )
            .toList(),
      );

    /// Handle the image
    final directory = await getApplicationDocumentsDirectory();
    final localFile = File(path.join(directory.path, 'item_images', item.id));
    await localFile.writeAsBytes(File(item.imagePath!).readAsBytesSync());
    return ItemSchema(
      id: item.id,
      color: colorList,
      classification: classificationList,
      occasions: occasionList,
      imagePath: item.id,
      favorite: item.favorite,
    );
  }

  /// Returns an item based on this instance values
  Item toItem() => Item(
        id: id,
        color: _getFromColorList(color),
        classification: _getFromClassificationList(classification),
        occasions: occasions.map((e) => e.toEsnapOccasion()).toList(),
        imagePath: imagePath,
        favorite: favorite,
      );
}

/// Gets the list from the hive object and returns the first object
EsnapColor? _getFromColorList(
  HiveList<HiveObjectMixin> colors,
) {
  final list = colors.map((e) => (e as ColorSchema).toEsnapColor()).toList();
  if (list.isEmpty) return null;
  return list[0];
}

/// Gets the list from the hive object and returns the first object
EsnapClassification? _getFromClassificationList(
  HiveList<HiveObjectMixin> classifications,
) {
  final list = classifications
      .map((e) => (e as ClassificationSchema).toEsnapClassification())
      .toList();
  if (list.isEmpty) return null;
  return list[0];
}
