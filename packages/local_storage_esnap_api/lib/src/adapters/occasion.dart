import 'package:esnap_api/esnap_api.dart';
import 'package:hive/hive.dart';

part 'occasion.g.dart';

/// A Hive class mimmicking the EsnapOccasion class
@HiveType(typeId: 4)
class OccasionSchema extends HiveObject {
  /// Basic constructor
  OccasionSchema({required this.id, required this.name});

  /// Convenient constructor from EsnapColor
  factory OccasionSchema.fromEsnapOccasion(EsnapOccasion occasion) =>
      OccasionSchema(id: occasion.id, name: occasion.name);

  /// The unique id for the occasion
  @HiveField(0)
  String id;

  /// The occasion name
  @HiveField(1)
  String name;

  /// Convenient transformer
  EsnapOccasion toEsnapOccasion() => EsnapOccasion(id: id, name: name);
}
