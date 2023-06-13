import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:esnap_api/esnap_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

// part 'item.g.dart';

/// {@template item}
/// A single `item`.
///
/// Contains a [color], [classification], [occasions], and [image].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Item]s are immutable and can be copied using [copyWith].
/// {@endtemplate}
@immutable
@JsonSerializable()
class Item extends Equatable {
  /// {@macro item}
  Item({
    required this.classification,
    required this.image,
    this.color,
    String? id,
    this.occasions = const [],
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the `item`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `item`'s color.
  final EsnapColor? color;

  /// The `item`'s classification.
  final EsnapClassification? classification;

  /// A list of the `item`'s occasions.
  ///
  /// Defaults to an empty list.
  final List<EsnapOccasion> occasions;

  /// The image of the `item`.
  ///
  /// Cannot be empty.
  final File image;

  /// Returns a copy of this `item` with the given values updated.
  ///
  /// {@macro item}
  Item copyWith({
    String? id,
    EsnapColor? color,
    EsnapClassification? classification,
    List<EsnapOccasion>? occasions,
    File? image,
  }) {
    return Item(
      id: id ?? this.id,
      color: (color ?? this.color)?.copyWith(),
      classification: (classification ?? this.classification)?.copyWith(),
      occasions:
          (occasions ?? this.occasions).map((o) => o.copyWith()).toList(),
      image: image ?? this.image,
    );
  }

  /// Deserializes the given [JsonMap] into a [Item].
  // static Item fromJson(JsonMap json) => _$ItemFromJson(json);

  /// Converts this [Item] into a [JsonMap].
  // JsonMap toJson() => _$ItemToJson(this);

  @override
  List<Object?> get props => [id, color, classification, occasions, image];
}
