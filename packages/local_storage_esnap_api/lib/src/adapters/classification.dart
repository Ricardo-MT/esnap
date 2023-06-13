import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';

part 'classification.g.dart';

/// A Hive class mimmicking the EsnapClassification class
@HiveType(typeId: 3)
class ClassificationSchema extends HiveObject {
  /// Basic constructor
  ClassificationSchema({required this.id, required this.name});

  /// Convenient constructor from EsnapColor
  factory ClassificationSchema.fromClassificationSchema(
    EsnapClassification classification,
  ) =>
      ClassificationSchema(id: classification.id, name: classification.name);

  /// The unique id for the classification
  @HiveField(0)
  String id;

  /// The classification name
  @HiveField(1)
  String name;

  /// Convenient transformer
  EsnapClassification toEsnapClassification() =>
      EsnapClassification(id: id, name: name);
}
