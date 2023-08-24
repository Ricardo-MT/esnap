import 'package:equatable/equatable.dart';
import 'package:esnap_api/esnap_api.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template classification}
/// A single `EsnapClassification`.
///
/// Contains a [id], [name] and [classificationType].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [EsnapClassification]s are immutable and can be copied using [copyWith].
/// {@endtemplate}
@immutable
class EsnapClassification extends Equatable {
  /// {@macro classification}
  EsnapClassification({
    required this.name,
    required this.classificationType,
    String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? '$name-${const Uuid().v4()}';

  /// The unique identifier of the `EsnapClassification`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `EsnapClassification`'s classification.
  ///
  /// Cannot be empty.
  final String name;

  /// The `EsnapClassification`'s classification.
  ///
  /// Cannot be empty.
  final EsnapClassificationType classificationType;

  /// Returns a copy of this `EsnapClassification` with the given values updated.
  ///
  /// {@macro classification}
  EsnapClassification copyWith({
    String? id,
    String? name,
    EsnapClassificationType? classificationType,
  }) {
    return EsnapClassification(
      id: id ?? this.id,
      name: name ?? this.name,
      classificationType: classificationType ?? this.classificationType,
    );
  }

  @override
  List<Object> get props => [id, name, classificationType];
}
