import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';

part 'color_translation.g.dart';

/// A Hive class mimmicking the EsnapColorTranslation class
@HiveType(typeId: 9)
class ColorTranslationSchema extends HiveObject {
  /// Basic constructor
  ColorTranslationSchema({
    required this.id,
    required this.name,
    required this.colorId,
    required this.languageCode,
  });

  /// Convenient constructor from EsnapColorTranslation
  factory ColorTranslationSchema.fromEsnapColorTranslation(
    EsnapColorTranslation color,
  ) {
    return ColorTranslationSchema(
      id: color.id,
      name: color.name,
      colorId: color.colorId,
      languageCode: color.languageCode,
    );
  }

  /// The unique id for this translation.
  @HiveField(0)
  String id;

  /// The resulted text from translating [EsnapColor.name] to the
  /// [languageCode] language.
  @HiveField(1)
  String name;

  /// The color id of the color this translation corresponds.
  @HiveField(2)
  String colorId;

  /// The color language code.
  @HiveField(3)
  String languageCode;

  /// Convenient transformer.
  EsnapColorTranslation toEsnapColor() => EsnapColorTranslation(
        id: id,
        name: name,
        colorId: colorId,
        languageCode: languageCode,
      );
}
