import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';

part 'classification_type.g.dart';

/// A Hive class mimmicking the EsnapClassificationType class
@HiveType(typeId: 5)
class ClassificationTypeSchema extends HiveObject {
  /// Basic constructor
  ClassificationTypeSchema({required this.id, required this.name});

  /// Convenient constructor from EsnapColor
  factory ClassificationTypeSchema.fromEsnapClassificationType(
    EsnapClassificationType classificationType,
  ) =>
      ClassificationTypeSchema(
        id: classificationType.id,
        name: classificationType.name,
      );

  /// The unique id for the classificationType
  @HiveField(0)
  String id;

  /// The classificationType name
  @HiveField(1)
  String name;

  /// Convenient transformer
  EsnapClassificationType toEsnapClassificationType() =>
      EsnapClassificationType(id: id, name: name);
}
