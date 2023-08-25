import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';
import 'package:local_storage_esnap_api/src/adapters/classification_type.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';

part 'classification.g.dart';

/// A Hive class mimmicking the EsnapClassification class
@HiveType(typeId: 3)
class ClassificationSchema extends HiveObject {
  /// Basic constructor
  ClassificationSchema({
    required this.id,
    required this.name,
    required this.classificationType,
  });

  /// Convenient constructor from EsnapColor
  factory ClassificationSchema.fromClassificationSchema(
    EsnapClassification classification,
  ) {
    final box =
        Hive.box<ClassificationTypeSchema>(EsnapBoxes.classificationType);
    final list = HiveList<ClassificationTypeSchema>(
      box,
    );
    list.add(box.get(classification.classificationType.id)!);
    return ClassificationSchema(
      id: classification.id,
      name: classification.name,
      classificationType: list,
    );
  }

  /// The unique id for the classification
  @HiveField(0)
  String id;

  /// The classification name
  @HiveField(1)
  String name;

  /// The classification type
  @HiveField(2)
  HiveList<ClassificationTypeSchema> classificationType;

  /// Convenient transformer
  EsnapClassification toEsnapClassification() => EsnapClassification(
        id: id,
        name: name,
        classificationType:
            classificationType.first.toEsnapClassificationType(),
      );
}
