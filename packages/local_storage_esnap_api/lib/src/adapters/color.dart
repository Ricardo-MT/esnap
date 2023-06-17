import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';

part 'color.g.dart';

/// A Hive class mimmicking the EsnapColor class
@HiveType(typeId: 2)
class ColorSchema extends HiveObject {
  /// Basic constructor
  ColorSchema({
    required this.id,
    required this.name,
    required this.hexColor,
  });

  /// Convenient constructor from EsnapColor
  factory ColorSchema.fromEsnapColor(EsnapColor color) => ColorSchema(
        id: color.id,
        name: color.name,
        hexColor: color.hexColor,
      );

  /// The unique id for the color
  @HiveField(0)
  String id;

  /// The color name
  @HiveField(1)
  String name;

  /// The color name
  @HiveField(2)
  int hexColor;

  /// Convenient transformer to EsnapColor
  EsnapColor toEsnapColor() => EsnapColor(
        id: id,
        name: name,
        hexColor: hexColor,
      );
}
